extends EffectCheck
# MST.append(e)


func check_actions_correct() -> bool:
	return true

# Append the edge to the mst
func _trigger_on_next_line_side_effect():
	var e: EdgeADT = StoredData.get_variable("e")
	var mst: ArrayADT = StoredData.get_variable("MST")
	if e and mst:
		mst.add_data(e)
