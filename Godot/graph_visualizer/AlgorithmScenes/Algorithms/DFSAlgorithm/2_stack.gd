extends EffectCheck

# s = Stack()

func check_actions_correct() -> bool:
	return true

func _trigger_on_next_line_side_effect():
	var stack = StackADT.new()
	StoredData.add_variable("s", stack)
	StoredData.adt_to_be_created = null


