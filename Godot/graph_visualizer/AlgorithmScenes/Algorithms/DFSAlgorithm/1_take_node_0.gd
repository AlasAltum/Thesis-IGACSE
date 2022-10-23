extends EffectCheck
# t = starting_node;

#func check_actions_correct() -> bool:
##	_trigger_on_next_line_side_effect()
##	var selected_nodes = StoredData.get_selected_nodes()
##	if selected_nodes.size() == 1 && selected_nodes[0].index == 0:
##		StoredData.add_variable("t", selected_nodes[0])
#		return true
#	return false

func _trigger_on_next_line_side_effect() -> void:
	var t = StoredData.nodes[0]
	StoredData.add_variable("t", t)
## Once we are in this line, node 0 may be added
#func effect_check_on_focused():
#	StoredData.selectable_nodes.append(0)

