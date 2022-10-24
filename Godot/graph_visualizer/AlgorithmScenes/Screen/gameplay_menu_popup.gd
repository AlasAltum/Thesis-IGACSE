class_name GameplayMenuPopup
extends WindowDialog


func _ready() -> void:
	# Needed for the Notification Manager to show when the game is finished
	$ResetButton.connect("pressed", self, "_on_ResetButton_pressed")
	$MenuButton.connect("pressed", self, "_on_MenuButton_pressed")
	var main_node = get_tree().get_root().get_node("Main")
	main_node.gameplay_menu_popup = self

func _input(event):
	if event.is_action_pressed("Menu") and self.visible:
		call_deferred("hide")


func _on_ResetButton_pressed() -> void:
	NotificationManager.reset_game()

func _on_MenuButton_pressed():
	var main_node = StoredData.get_tree().root.get_node("./Main")
	main_node.queue_free()
	call_deferred("_deferred_goto_scene", "res://GameFlow/MainMenu.tscn")

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
