extends EffectCheck
# Set A = {v, w}

# 
func check_actions_correct() -> bool:
	return true

func _trigger_on_next_line_side_effect() -> void:
	var set_a = SetADT.new()
	set_a.append(StoredData.get_variable("v"))
	set_a.append(StoredData.get_variable("w"))
	StoredData.add_variable("A", set_a)

