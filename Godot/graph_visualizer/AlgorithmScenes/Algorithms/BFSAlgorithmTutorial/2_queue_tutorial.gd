extends EffectCheck
# q = Queue()

func check_actions_correct() -> bool:
	if StoredData.has_variable("q"):
		if "Queue" in StoredData.get_data_type_of_variable("q"):
			return true
	return false


func _trigger_on_next_line_side_effect() -> void:
	# Stop highlighting the queue slot in Data Structures
	StoredData.animation_player.stop_queue_highlight_once()
	# Show the popup explaining what the current variable is
	# Because in the next instruction the user has to manipulate it
	StoredData.animation_player.show_current_variable_popup()
