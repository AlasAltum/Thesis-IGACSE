extends EffectCheck
# A.append(e)

func _trigger_on_next_line_side_effect():
	var a : SetADT = StoredData.get_variable("A")
	a.add_data(StoredData.get_variable("v"))
	a.add_data(StoredData.get_variable("w"))
