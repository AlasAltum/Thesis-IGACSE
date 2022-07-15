extends EffectCheck

# Make sure that user has created a queue with name q and it has the node(0). 
func check_actions_correct() -> bool:
	if StoredData.has_variable("s") and StoredData.has_variable("t"):
		if StoredData.get_variable("s").as_string() == "Stack((0))":
			return true
	return false
