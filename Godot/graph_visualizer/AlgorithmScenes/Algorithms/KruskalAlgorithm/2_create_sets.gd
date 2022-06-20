extends EffectCheck


func check_actions_correct() -> bool:
	if StoredData.has_variable("s"):
		if "Stack" in StoredData.get_data_type_of_variable("s"):
			return true
	return false
