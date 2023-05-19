class_name FinishedPopup
extends WindowDialog

export (String) var explanation_in_label = "Congratulations! You have successfully finished the BFS Algorithm!"


func _ready() -> void:
	# Needed for the Notification Manager to show when the game is finished
	NotificationManager.finished_popup = self
	$VBoxContainer/ResetButton.connect("pressed", self, "_on_ResetButton_pressed")
	$VBoxContainer/MenuButton.connect("pressed", self, "_on_MenuButton_pressed")
	$Explanation.text = explanation_in_label
	var close_button : TextureButton = get_close_button()
	close_button.visible = false

func _notification(what):
	if what == NOTIFICATION_POST_POPUP:
		StoredData.popup_captures_input = true
		$VBoxContainer/MenuButton.grab_focus()
	elif what == NOTIFICATION_POPUP_HIDE:
		StoredData.popup_captures_input = false


func _on_ResetButton_pressed() -> void:
	AudioPlayer.stop_playing_music()
	NotificationManager.reset_game()

func _on_MenuButton_pressed():
	AudioPlayer.play_button_sound()
	StoredData.world_node.go_back_to_menu()

func _deferred_goto_scene(path):
	var s = ResourceLoader.load(path)
	var current_scene = s.instance()
	StoredData.get_tree().root.add_child(current_scene)
	StoredData.get_tree().current_scene = current_scene


func _on_FinishedPopup_about_to_show():
	StoredData.popup_captures_input = true
	$VBoxContainer/MenuButton.grab_focus()
	$VBoxContainer/MenuButton.grab_click_focus()


func _on_FinishedPopup_popup_hide():
	StoredData.popup_captures_input = false
