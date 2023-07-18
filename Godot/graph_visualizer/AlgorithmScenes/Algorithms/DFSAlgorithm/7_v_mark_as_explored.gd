extends EffectCheck
# v.mark_as_explored()


func check_actions_correct() -> bool:
	var v : AGraphNode = StoredData.get_variable("v").get_node()
	if v in StoredData.get_selected_nodes():
		return true  # This is not required
	return false

# Once we are in this line, node v may be added
func effect_check_on_focused():
	var v : AGraphNode = StoredData.get_variable("v").get_node()
	StoredData.selectable_nodes_indexes.append(v.index)

