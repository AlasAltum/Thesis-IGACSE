extends EffectCheck
# q.add(u)

func effect_check_on_focused():
	var u = StoredData.get_variable("u").get_node()
	StoredData.add_node_to_nodes_that_should_be_added_to_adt(u)
	StoredData.allow_nodes_dragging = true  # To allow also dragging nodes


func check_actions_correct() -> bool:
	if StoredData.has_variable("q") and StoredData.has_variable("u"):
		var u: AGraphNode = StoredData.get_variable("u").get_node()
		var u_as_string: String = u.as_string()
		# It will show Queue() if it is empty. The player must add the u node
		if u_as_string in StoredData.get_variable("q").as_string():
			StoredData.allow_nodes_dragging = false
			return true
	return false

func _trigger_on_next_line_side_effect():
	StoredData.highlighted_edge.set_is_highlighted(false)
	StoredData.set_highlighted_edge(null)
