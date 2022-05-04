extends EffectCheck


func check_actions_correct() -> bool:
	var selected_nodes = StoredData.get_selected_nodes()
	if selected_nodes.size() == 1 && selected_nodes[0].index == 0:
		StoredData.add_variable("t", selected_nodes[0])
		return true
	return false

# Once we are in this line, node 0 may be added
func effect_check_on_focused():
	StoredData.selectable_nodes.append(0)

