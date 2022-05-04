extends EffectCheck


func check_actions_correct() -> bool:
	if StoredData.has_variable("q"):
		if "Queue" in StoredData.get_data_type_of_variable("q"):
			return true
	return false
