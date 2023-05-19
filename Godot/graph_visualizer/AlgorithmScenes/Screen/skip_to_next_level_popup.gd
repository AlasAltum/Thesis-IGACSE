class_name ShowSkipToNextLevelPopup
extends WindowDialog

func _ready():
	NotificationManager.skip_to_next_level_popup = self


func _on_NextLevelButton_pressed():
	StoredData.world_node.go_to_random_level()


func _on_MenuButton_pressed():
	AudioPlayer.play_button_sound()
	StoredData.world_node.go_back_to_menu()

func _notification(what):
	if what == NOTIFICATION_POST_POPUP:
		StoredData.popup_captures_input = true
		$VBoxContainer/NextLevelButton.grab_focus()
		$VBoxContainer/NextLevelButton.grab_click_focus()
	elif what == NOTIFICATION_POPUP_HIDE:
		StoredData.popup_captures_input = false
	
