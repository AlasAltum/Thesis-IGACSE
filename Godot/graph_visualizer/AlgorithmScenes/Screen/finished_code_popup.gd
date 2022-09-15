extends WindowDialog


func _ready() -> void:
	# Needed for the Notification Manager to show when the game is finished
	NotificationManager.finished_popup = self


func _on_ResetButton_pressed() -> void:
	NotificationManager.reset_game()


func _on_MenuButton_pressed():
	# TODO: Add 
	goto_scene("res://GameFlow/AlgorithmSelectionMenu.tscn")


func goto_scene(path):
	call_deferred("_deferred_goto_scene", path)


func _deferred_goto_scene(path):
	var s = ResourceLoader.load(path)
	var current_scene = s.instance()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
