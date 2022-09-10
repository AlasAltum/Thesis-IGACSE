extends EffectCheck
# MST.append(e)


func check_actions_correct() -> bool:
	var mst : ArrayADT = StoredData.get_variable("MST")
	var e: EdgeADT = StoredData.get_variable("e")
	var mst_string = mst.as_string()
	var e_string = e.as_string()
	if mst and e and e_string in mst_string:
		return true
	return false


