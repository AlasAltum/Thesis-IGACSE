extends EffectCheck

# Press Enter
var has_enter_been_pressed : bool = false
var helping_timer: Timer


func effect_check_on_focused() -> void:
	if StoredData.world_node: # : SecondTutorial
		helping_timer = Timer.new()
		StoredData.world_node.add_child(helping_timer)
		helping_timer.one_shot = true
		helping_timer.connect("timeout", self, "on_user_takes_time_to_press_nodes")
		helping_timer.start(3.5)


# We want to help the user when not clicking the first node
func on_user_takes_time_to_press_nodes():
	var world = StoredData.world_node
	if world and world.starting_node:
		world.starting_node.show_animation_of_clicking_mouse()


func check_actions_correct() -> bool:
	return false

func _trigger_on_next_line_side_effect():
	pass
