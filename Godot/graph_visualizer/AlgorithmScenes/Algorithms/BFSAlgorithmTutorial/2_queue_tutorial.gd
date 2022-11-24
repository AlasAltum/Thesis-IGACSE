extends EffectCheck


func check_actions_correct() -> bool:
	if StoredData.has_variable("q"):
		if "Queue" in StoredData.get_data_type_of_variable("q"):
			StoredData.animation_player.stop_queue_highlight()
			return true
	return false

## tutorial version
func _trigger_on_next_line_side_effect() -> void:
	if StoredData.animation_player:
		StoredData.animation_player.queue("ShowVariablesPanel")
		StoredData.animation_player.show_variables_panel()
