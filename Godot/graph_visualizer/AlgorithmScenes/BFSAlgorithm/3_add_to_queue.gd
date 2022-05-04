extends EffectCheck

# Make sure that user has created a queue with name q and it has the node(0). 
func check_actions_correct() -> bool:
	if StoredData.has_variable("q") and StoredData.has_variable("t"):
		if StoredData.heap_dictionary["q"].as_string() == "Queue(Node(0))":
			return true
	return false
