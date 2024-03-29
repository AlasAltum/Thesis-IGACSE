class_name FinishCodeEffect
extends EffectCheck


func check_actions_correct() -> bool:
	return true

func _generate_message() -> String:
	return "IMPLEMENT THIS MESSAGE OVERRIDING THIS METHOD"

func effect_check_on_focused():
	NotificationManager.show_code_finished_popup(self._generate_message())
	_mark_level_as_finished()
	self._reset_data()

func _reset_data():
	NotificationManager.reset_data()

func _mark_level_as_finished():
	# Only playable levels should be marked as finished.
	if StoredData.world_node and StoredData.world_node.get_class() == "GraphManager":
		StoredData.finished_levels[StoredData.world_node.level_name] = true
		# Remove the level from the remaining levels to finish, so we cannot get into it the next time
		StoredData.remaining_levels_to_finish.erase(StoredData.world_node.level_name)


# TODO: Erase this once the game has been fully tested
func goto_scene(path):
	NotificationManager.go_to_scene(path)

# func _deferred_goto_scene(path):
# 	var s = ResourceLoader.load(path)
# 	var current_scene = s.instance()
# 	StoredData.get_tree().root.add_child(current_scene)
# 	StoredData.get_tree().current_scene = current_scene

