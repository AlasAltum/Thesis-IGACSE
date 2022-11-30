extends EffectCheck
# v = s.pop()

var audio: AudioStreamPlayer = null
var pop_stream: AudioStreamOGGVorbis = preload("res://AlgorithmScenes/Audio/pop.ogg")



func check_actions_correct() -> bool:
	return true  # This is not required

# When entering next line
func execute_side_effect() -> void:
	if StoredData.has_variable("s"):
		var stack : StackADT = StoredData.get_variable("s")
		var top_node_in_stack : AGraphNode = stack.top()
		StoredData.add_variable("v", top_node_in_stack)
		_play_pop_sound()

func _play_pop_sound():
	audio = AudioStreamPlayer.new()
	StoredData.add_child(audio)
	pop_stream.set_loop(false)
	audio.stream = pop_stream
	audio.play()


func get_next_line() -> int:
	self.execute_side_effect()
	return .get_next_line()  # super.get_next_line()
