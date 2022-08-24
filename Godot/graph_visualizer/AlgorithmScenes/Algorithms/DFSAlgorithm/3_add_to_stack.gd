extends EffectCheck
# Set A = {v, w}

# 
func check_actions_correct() -> bool:
	return true

func _trigger_on_next_line_side_effect() -> void:
	var set_t = SetADT.new()
	set_t.append(StoredData.get_variable("v"))
	set_t.append(StoredData.get_variable("w"))
	StoredData.add_variable("T", set_t)

