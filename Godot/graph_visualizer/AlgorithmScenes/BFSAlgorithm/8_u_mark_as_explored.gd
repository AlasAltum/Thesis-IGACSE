extends EffectCheck
# u.mark_as_explored()


func check_actions_correct() -> bool:
	var u : AGraphNode = StoredData.get_variable("u")
	if u in StoredData.get_selected_nodes():
		return true  # This is not required
	return false

# Once we are in this line, node 0 may be added
func effect_check_on_focused():
	var u : AGraphNode = StoredData.get_variable("u")
	StoredData.selectable_nodes.append(u.index)

