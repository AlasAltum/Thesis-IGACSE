class_name GameplayMenuPopup
extends WindowDialog


func _ready() -> void:
	# Needed for the Notification Manager to show when the game is finished
	$VBoxContainer/ResetButton.connect("pressed", self, "_on_ResetButton_pressed")
	$VBoxContainer/MenuButton.connect("pressed", self, "_on_MenuButton_pressed")
	var main_node = get_tree().get_root().get_node("Main")
#	main_node.gameplay_menu_popup = self
	get_close_button().visible = false
	

func _input(event):
	# If there is no other popup capturing input
	if event.is_action_pressed("Menu") and not StoredData.popup_captures_input:
		if self.visible:
			call_deferred("hide")
		else:
			self.popup()

func _on_ResetButton_pressed() -> void:
	AudioPlayer.play_button_sound()
	NotificationManager.reset_game()
	self.visible = false

func _on_MenuButton_pressed():
	AudioPlayer.play_button_sound()
	StoredData.world_node.go_back_to_menu()
	self.visible = false

func _deferred_goto_scene(path):
	NotificationManager.go_to_scene(path)


func _on_ADTIsNotEmptyPopup_about_to_show():
	StoredData.popup_captures_input = true
	$YesButton.grab_focus()
	$YesButton.grab_click_focus()

func _on_ADTIsNotEmptyPopup_popup_hide():
	StoredData.popup_captures_input = false
