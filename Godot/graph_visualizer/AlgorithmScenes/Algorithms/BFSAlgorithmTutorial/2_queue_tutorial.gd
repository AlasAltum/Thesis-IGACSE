extends EffectCheck
# q = Queue()

func check_actions_correct() -> bool:
	if StoredData.has_variable("q"):
		if "Queue" in StoredData.get_data_type_of_variable("q"):
			return true
	return false


func _trigger_on_next_line_side_effect() -> void:
	StoredData.animation_player.stop_queue_highlight_once()
