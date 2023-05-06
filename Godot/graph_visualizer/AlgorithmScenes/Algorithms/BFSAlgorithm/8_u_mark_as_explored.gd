extends EffectCheck
# u.mark_as_explored()


# Once we are in this line, node u may be added
func effect_check_on_focused():
	var u : AGraphNode = StoredData.get_variable("u").get_node()
	StoredData.selectable_nodes.append(u.index)

func check_actions_correct() -> bool:
	var u : AGraphNode = StoredData.get_variable("u").get_node()
	if u in StoredData.get_selected_nodes():
		return true  # This is not required
	return false

func _trigger_on_next_line_side_effect() -> void:
	# Get the edge between nodes u and v and change its transparency
	var u : AGraphNode = StoredData.get_variable("u").get_node()
	var v : AGraphNode = StoredData.get_variable("v").get_node()
	for _edge in StoredData.edges:
		if (_edge.joint_end1 == u and _edge.joint_end2 == v) or \
		 (_edge.joint_end1 == v and _edge.joint_end2 == u):
			_edge.set_edge_transparency_as_explored()

