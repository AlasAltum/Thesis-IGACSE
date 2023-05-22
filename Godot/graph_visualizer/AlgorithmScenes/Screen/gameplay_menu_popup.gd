class_name GameplayMenuPopup
extends WindowDialog


func _ready() -> void:
	# Needed for the Notification Manager to show when the game is finished
	$VBoxContainer/ResetButton.connect("pressed", self, "_on_ResetButton_pressed")
	$VBoxContainer/MenuButton.connect("pressed", self, "_on_MenuButton_pressed")
	var main_node = get_tree().get_root().get_node("Main")
	main_node.gameplay_menu_popup = self

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

func _on_MenuButton_pressed():
	AudioPlayer.play_button_sound()
	StoredData.world_node.go_back_to_menu()

func _deferred_goto_scene(path):
	var s = ResourceLoader.load(path)
	var current_scene = s.instance()
	StoredData.get_tree().root.add_child(current_scene)
	StoredData.get_tree().current_scene = current_scene


func _on_ADTIsNotEmptyPopup_about_to_show():
	StoredData.popup_captures_input = true
	$YesButton.grab_focus()
	$YesButton.grab_click_focus()

func _on_ADTIsNotEmptyPopup_popup_hide():
	StoredData.popup_captures_input = false
