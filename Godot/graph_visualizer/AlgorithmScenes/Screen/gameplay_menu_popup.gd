class_name GameplayMenuPopup
extends WindowDialog


func _ready() -> void:
	# Needed for the Notification Manager to show when the game is finished
	$VBoxContainer/ResetButton.connect("pressed", self, "_on_ResetButton_pressed")
	$VBoxContainer/CloseButton.connect("pressed", self, "_on_CloseButton_pressed")
	$VBoxContainer/MenuButton.connect("pressed", self, "_on_MenuButton_pressed")
	var main_node = get_tree().get_root().get_node("Main")

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

func _on_CloseButton_pressed():
	AudioPlayer.play_button_sound()
	self.visible = false

func _on_MenuButton_pressed():
	AudioPlayer.play_button_sound()
	if is_instance_valid(StoredData.world_node) and StoredData.world_node.has_method("go_back_to_menu"):
		StoredData.world_node.go_back_to_menu()
	else:
		AudioPlayer.stop_playing_music() # Whatever the music soundtrack playing, stop it when coming back to the menu
		self.set_name("TempMain")
		self.queue_free()
		if is_instance_valid(StoredData.world_node):
			NotificationManager._deferred_goto_scene("res://GameFlow/MainMenu.tscn", true, StoredData.world_node)

	self.visible = false


func _deferred_goto_scene(path):
	NotificationManager.go_to_scene(path)


func _on_ADTIsNotEmptyPopup_about_to_show():
	StoredData.popup_captures_input = true
	$YesButton.grab_focus()
	$YesButton.grab_click_focus()

func _on_ADTIsNotEmptyPopup_popup_hide():
	StoredData.popup_captures_input = false
