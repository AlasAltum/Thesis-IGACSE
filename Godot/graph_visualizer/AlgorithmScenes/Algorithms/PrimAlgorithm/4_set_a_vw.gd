extends EffectCheck
# Set A = {v, w}

# Ask the user whether answer is true or false
func check_actions_correct() -> bool:
	return true


func _trigger_on_next_line_side_effect() -> void:
	var a = SetADT.new()
	a.add_data(StoredData.get_variable("w"))
	a.add_data(StoredData.get_variable("v"))
	StoredData.add_variable("A", a)
