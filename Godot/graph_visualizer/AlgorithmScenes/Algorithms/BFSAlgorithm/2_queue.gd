extends EffectCheck

# q = Queue()


func check_actions_correct() -> bool:
	return true


func _trigger_on_next_line_side_effect():
	var queue = QueueADT.new()
	StoredData.add_variable("q", queue)
	StoredData.adt_to_be_created = null
