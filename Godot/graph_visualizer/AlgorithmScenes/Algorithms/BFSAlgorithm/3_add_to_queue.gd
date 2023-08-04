extends EffectCheck

func effect_check_on_focused() -> void:
	var t : AGraphNode = StoredData.get_variable("t").get_node()
	StoredData.add_node_to_nodes_that_should_be_added_to_adt(t)

# Make sure that user has created a queue with name q and it has the node(0). 
func check_actions_correct() -> bool:
	if StoredData.has_variable("q") and StoredData.has_variable("t"):
		if StoredData.get_variable("q").as_string() == "Queue((0))":
			return true
	return false
