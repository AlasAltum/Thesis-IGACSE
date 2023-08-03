extends FinishCodeEffect
# finish code

func _trigger_on_next_line_side_effect():
	NotificationManager.show_code_finished_popup(self._generate_message())
	_mark_level_as_finished()
	self._reset_data()

func _reset_data():
	StoredData.reset_data()
	NotificationManager.reset_data()


func _generate_message() -> String:
	return "DFS Finished"
