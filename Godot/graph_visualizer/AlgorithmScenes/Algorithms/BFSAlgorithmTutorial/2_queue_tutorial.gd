extends EffectCheck
# q = Queue()

func check_actions_correct() -> bool:
	return true


func _trigger_on_next_line_side_effect() -> void:
	var generated_adt = QueueADT.new()
	StoredData.add_variable("q", generated_adt)
	# Stop highlighting the queue slot in Data Structures
	NotificationManager.animation_player.stop_queue_highlight_once()
	# Show the popup explaining what the current variable is
	# Because in the next instruction the user has to manipulate it
	NotificationManager.animation_player.show_current_variable_popup()
