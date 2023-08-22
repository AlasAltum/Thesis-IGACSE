extends EffectCheck
# s.add(2)


func effect_check_on_focused() -> void:
	var node_two : AGraphNode = StoredData.get_node_by_index(2)
	StoredData.add_node_to_nodes_that_should_be_added_to_adt(node_two)

# Make sure that user has created a stack with name s and it has the node(0). 
func check_actions_correct() -> bool:
	if StoredData.has_variable("s"):
		if StoredData.get_variable("s").as_string() == "Stack((0), (2))":
			return true
	return false
