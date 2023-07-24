extends EffectCheck

# Press Enter
var side_effect_has_been_executed : bool = false
var helping_timer: Timer
var node_0: AGraphNode

func effect_check_on_focused() -> void:
	# Set the node 0 that must   be selected
	if StoredData.world_node: # : SecondTutorial
		for _node in StoredData.nodes:
			if is_instance_valid(_node) and _node.index == 0:
				node_0 = _node
				StoredData.selectable_nodes_indexes.append(0)
				break

		helping_timer = Timer.new()
		StoredData.world_node.add_child(helping_timer)
		helping_timer.start(5)
		helping_timer.connect("timeout", self, "on_timeout_help_user")


func on_timeout_help_user():
	if node_0 and is_instance_valid(helping_timer):
		node_0.show_animation_of_clicking_mouse()

func check_actions_correct() -> bool:
	if node_0 and node_0.selected:
		if helping_timer and is_instance_valid(helping_timer):
			helping_timer.queue_free()
		if not side_effect_has_been_executed:
			side_effect_has_been_executed = true
			node_0.highlight_variable("t")
			node_0.on_ship_arrived() # Show the base
		return true
	return false
