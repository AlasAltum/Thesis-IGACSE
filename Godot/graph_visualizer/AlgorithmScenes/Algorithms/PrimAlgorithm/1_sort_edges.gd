extends EffectCheck


func check_actions_correct() -> bool:
	var selected_nodes = StoredData.get_selected_nodes()
	if selected_nodes.size() == 1 && selected_nodes[0].index == 0:
		StoredData.add_variable("t", selected_nodes[0])
		return true
	return false


func effect_check_on_focused():
	# Try to select all edges
	print("Select edges")

