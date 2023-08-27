extends EffectCheck
# t = starting_node;
var node_0: AGraphNode
var helping_timer: Timer

func effect_check_on_focused() -> void:
	var t = StoredData.nodes[0]
	t.highlight_node()

	if StoredData.world_node: # : SecondTutorial
		node_0 = StoredData.get_node_by_index(0)
		node_0.should_show_base_when_selected = false
		StoredData.selectable_nodes_indexes.append(0)

	helping_timer = Timer.new()
	StoredData.world_node.add_child(helping_timer)
	helping_timer.start(5)
	helping_timer.connect("timeout", self, "on_timeout_help_user")

func check_actions_correct():
	if is_instance_valid(node_0):
		if node_0.selected:
			return true
	return false

func _trigger_on_correct_once() -> void:
	if helping_timer and is_instance_valid(helping_timer):
		helping_timer.queue_free()

func on_timeout_help_user():
	if node_0 and is_instance_valid(helping_timer):
		node_0.show_animation_of_clicking_mouse()

func _trigger_on_next_line_side_effect() -> void:
	var t = StoredData.nodes[0]
	StoredData.add_variable("t", t.get_adt())
	t.unhighlight_node()
	# This is a trick, so the user must click the node 0 at the beginning
	# and then click node 0 later on the same game
	node_0.should_show_base_when_selected = true
	node_0.selected = false
