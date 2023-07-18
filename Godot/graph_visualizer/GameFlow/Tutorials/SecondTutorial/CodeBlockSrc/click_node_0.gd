extends EffectCheck

# Press Enter
var has_enter_been_pressed : bool = false
var helping_timer: Timer
var node_0: AGraphNode = null

func effect_check_on_focused() -> void:
	# Set the node 0 that must be selected
	if StoredData.world_node: # : SecondTutorial
		for _node in StoredData.nodes:
			if _node.index == 0:
				node_0 = _node
				StoredData.selectable_nodes_indexes.append(0)

# We want to help the user when not clicking the first node
func on_user_takes_time_to_press_nodes():
	var world = StoredData.world_node
	if world and world.starting_node:
		world.starting_node.show_animation_of_clicking_mouse()


func check_actions_correct() -> bool:
	return false

func _trigger_on_next_line_side_effect():
	pass
