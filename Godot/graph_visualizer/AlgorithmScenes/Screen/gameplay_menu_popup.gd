class_name GameplayMenuPopup
extends WindowDialog


func _ready() -> void:
	# Needed for the Notification Manager to show when the game is finished
	$ResetButton.connect("pressed", self, "_on_ResetButton_pressed")
	$MenuButton.connect("pressed", self, "_on_MenuButton_pressed")
	var main_node = get_tree().get_root().get_node("Main")
	main_node.gameplay_menu_popup = self


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
