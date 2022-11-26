extends EffectCheck


func effect_check_on_focused():
	var u = StoredData.get_variable("u").get_node()
	StoredData.add_node_to_nodes_that_should_be_added_to_adt(u)


func check_actions_correct() -> bool:
	if StoredData.has_variable("q") and StoredData.has_variable("u"):
		var u: AGraphNode = StoredData.get_variable("u").get_node()
		var u_as_string: String = u.as_string()
		# It will show Queue() if it is empty. The player must add the u node
		if u_as_string in StoredData.get_variable("q").as_string():
			return true
	return false
