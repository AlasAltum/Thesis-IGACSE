extends EffectCheck
# Set A = {v, w}

# Ask the user whether answer is true or false
func check_actions_correct() -> bool:
	return true


func _trigger_on_next_line_side_effect() -> void:
	var t = SetADT.new()
	t.add_data(StoredData.get_variable("v"))
	t.add_data(StoredData.get_variable("w"))
	StoredData.add_variable("T", t)
