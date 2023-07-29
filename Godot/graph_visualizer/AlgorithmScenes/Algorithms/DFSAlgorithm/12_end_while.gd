extends EffectCheck
# endwhile;

# it will always jump to the while.
func get_next_line() -> int:
	return .get_jump_line()

func _trigger_on_next_line_side_effect():
	NotificationManager.show_code_finished_popup(self._generate_message())
	_mark_level_as_finished()
	self._reset_data()

func _generate_message() -> String:
	return "DFS Finished"

func _reset_data():
	StoredData.reset_data()
	NotificationManager.reset_data()

func _mark_level_as_finished():
	# Only playable levels should be marked as finished.
	if StoredData.world_node and StoredData.world_node.get_class() == "GraphManager":
		StoredData.finished_levels[StoredData.world_node.level_name] = true
		# Remove the level from the remaining levels to finish, so we cannot get into it the next time
		StoredData.remaining_levels_to_finish.erase(StoredData.world_node.level_name)

func effect_check_on_focused() -> void:
	NotificationManager.show_code_finished_popup(self._generate_message())
	_mark_level_as_finished()
	self._reset_data()

# TODO: Erase this once the game has been fully tested
func goto_scene(path):
	NotificationManager.go_to_scene(path)
