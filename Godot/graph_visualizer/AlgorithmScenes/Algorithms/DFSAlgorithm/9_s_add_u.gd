extends EffectCheck
# s.add(u)


func effect_check_on_focused() -> void:
	var u : AGraphNode = StoredData.get_variable("u").get_node()
	StoredData.add_node_to_nodes_that_should_be_added_to_adt(u)

# check that node U is inside stack S
func check_actions_correct() -> bool:
	if StoredData.has_variable("s") and StoredData.has_variable("u"):
		var u: AGraphNode = StoredData.get_variable("u").get_node()
		var u_as_string: String = u.as_string()
		# It will show Stack() if it is empty. The player must add the u node
		# in order to show u_as_string inside the string of s
		if u_as_string in StoredData.get_variable("s").as_string():
			return true
	return false


# func _trigger_on_next_line_side_effect():
# 	StoredData.highlighted_edge.set_is_highlighted(false)
# 	StoredData.set_highlighted_edge(null)
