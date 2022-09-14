extends WindowDialog


func _ready() -> void:
	# Needed for the Notification Manager to show when the game is finished
	NotificationManager.finished_popup = self


func _on_ResetButton_pressed() -> void:
	NotificationManager.reset_game()


func _on_MenuButton_pressed():
	# TODO: Add 
	pass
