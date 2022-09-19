extends EffectCheck
# s.add(t)

# Make sure that user has created a stack with name s and it has the node(0). 
func check_actions_correct() -> bool:
	if StoredData.has_variable("s") and StoredData.has_variable("s"):
		if StoredData.get_variable("s").as_string() == "Stack((0))":
			return true
	return false

