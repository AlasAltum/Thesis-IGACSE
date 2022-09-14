extends EffectCheck
# finish code
var message: String = "BFS Finished"


# TODO: Add notification
func effect_check_on_focused() -> void:
	NotificationManager.on_code_finished_popup(message)

func check_actions_correct() -> bool:
	return true
