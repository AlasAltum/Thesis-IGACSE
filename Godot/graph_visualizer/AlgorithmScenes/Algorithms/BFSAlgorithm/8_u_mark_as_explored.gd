extends EffectCheck
# u.mark_as_explored()

var executed_on_correct_effect_once: bool = false

# We reset this variable to false each time the instruction pointer passes here
# So the ship is sent again
func reset():
	executed_on_correct_effect_once = false

# Once we are in this line, node u may be added
func effect_check_on_focused():
	var u : AGraphNode = StoredData.get_variable("u").get_node()
	u.show_animation_of_clicking_mouse()
	u.highlight_node()
	StoredData.selectable_nodes_indexes.append(u.index)

func _edge_connects_nodes_u_and_v(_edge, u, v):
	if (_edge.joint_end1 == u and _edge.joint_end2 == v) or \
		(_edge.joint_end1 == v and _edge.joint_end2 == u):
		return true
	return false

# We try to make this level shorter by checking if all nodes were already explored. Then we allow the user to skip the level.
# We want to allow the user to skip the level once all nodes were explored
func _check_for_skip_level():
	var explored_nodes = []
	for node in StoredData.nodes:
		if node.is_iterated_or_explored():
			explored_nodes.append(node)

	if StoredData.nodes.size() == explored_nodes.size():
		# Allow the user to skip level by showing a popup
		NotificationManager.show_skip_to_next_level_popup()


# We want to see the ship moving from node v to node u as soon as the
# correct node u is pressed
func on_action_correct_execute_once(u: Node2D):
	if not executed_on_correct_effect_once:
		var v : AGraphNode = StoredData.get_variable("v").get_node()
		for _edge in StoredData.edges:
			if _edge_connects_nodes_u_and_v(_edge, u, v):
				_edge.send_ship_from_nodeA_to_nodeB(v, u)
				executed_on_correct_effect_once = true

		_check_for_skip_level()

func check_actions_correct() -> bool:
	var u_var  = StoredData.get_variable("u")
	if u_var:
		var u : AGraphNode = u_var.get_node()
		if u in StoredData.get_selected_nodes():
			on_action_correct_execute_once(u)
			return true  # This is not required

	return false

func _trigger_on_next_line_side_effect() -> void:
	# Get the edge between nodes u and v and change its transparency
	var u : AGraphNode = StoredData.get_variable("u").get_node()
	var v : AGraphNode = StoredData.get_variable("v").get_node()
	for _edge in StoredData.edges:
		if _edge_connects_nodes_u_and_v(_edge, u, v):
			_edge.set_edge_transparency_as_explored()

