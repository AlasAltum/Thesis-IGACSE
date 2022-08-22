extends EffectCheck
# finish code
var message: String = "BFS Finished"

func _init():
	code_line = null

# TODO: Add notification
func side_effect() -> void:
	NotificationManager.on_code_finished_popup(message)

func check_actions_correct() -> bool:
	self.side_effect()
	return true
