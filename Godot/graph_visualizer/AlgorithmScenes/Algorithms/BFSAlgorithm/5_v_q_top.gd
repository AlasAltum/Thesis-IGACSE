extends EffectCheck
# v = q.top()

var audio: AudioStreamPlayer = null
var pop_stream: AudioStreamOGGVorbis = preload("res://AlgorithmScenes/Audio/pop.ogg")


func check_actions_correct() -> bool:
	return true  # This is not required

func execute_side_effect() -> void:
	if StoredData.has_variable("q"):
		var queue : QueueADT = StoredData.get_variable("q")
		var top_node_in_queue : AGraphNode = queue.top()
		if top_node_in_queue:
			StoredData.add_variable("v", top_node_in_queue.get_adt())
			StoredData.highlight_variable("v")
			_play_pop_sound()

func _play_pop_sound():
	audio = AudioStreamPlayer.new()
	StoredData.add_child(audio)
	pop_stream.set_loop(false)
	audio.stream = pop_stream
	audio.play()

func _stop_pop_sound():
	audio.stop()
	StoredData.remove_child(audio)



func get_next_line() -> int:
	self.execute_side_effect()
	return .get_next_line()  # super.get_next_line()
