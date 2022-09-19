class_name FinishCodeEffect
extends EffectCheck



func _generate_message() -> String:
	return "IMPLEMENT THIS MESSAGE OVERRIDING THIS METHOD"

func _reset_data():
	StoredData.reset_data()
	NotificationManager.reset_data()

func _check_level_finished():
	var main_node: GraphManager = StoredData.get_tree().root.get_node("./Main")
	StoredData.finished_levels[main_node.level_name] = true

# TODO: Add notification
func effect_check_on_focused() -> void:
	_check_level_finished()
	NotificationManager.on_code_finished_popup(self._generate_message())
	self._reset_data()  # Mark level as finished
	var main_node: GraphManager = StoredData.get_tree().root.get_node("./Main")
	main_node.queue_free()
	goto_scene("res://GameFlow/AlgorithmSelectionMenu.tscn")

func check_actions_correct() -> bool:
	return true


func goto_scene(path):
	call_deferred("_deferred_goto_scene", path)

func _deferred_goto_scene(path):
	var s = ResourceLoader.load(path)
	var current_scene = s.instance()
	StoredData.get_tree().root.add_child(current_scene)
	StoredData.get_tree().current_scene = current_scene
