extends EffectCheck
# v = s.pop()

var audio: AudioStreamPlayer = null


func check_actions_correct() -> bool:
	return true  # This is not required

# When entering next line
func execute_side_effect() -> void:
	if StoredData.has_variable("s"):
		var stack : StackADT = StoredData.get_variable("s")
		var top_node_in_stack : AGraphNode = stack.top()
		StoredData.add_variable("v", top_node_in_stack)
		_play_pop_sound()
		# Add this to highlight node v in some way
		# var v = StoredData.get_variable("v").get_node()
		# v.highlight_node()

func _play_pop_sound():
	AudioPlayer.play_pop_sound()

func get_next_line() -> int:
	self.execute_side_effect()
	return .get_next_line()  # super.get_next_line()
