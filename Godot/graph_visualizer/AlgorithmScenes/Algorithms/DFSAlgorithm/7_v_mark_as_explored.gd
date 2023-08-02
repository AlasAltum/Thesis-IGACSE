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

#func _trigger_on_next_line_side_effect():
#	var v : AGraphNode = StoredData.get_variable("v").get_node()
#	# The first time we should skip sending the ship from node v to u
#	if v == StoredData.get_variable("t").get_node():
#		return
#
#	var u : AGraphNode = StoredData.get_variable("u").get_node() 
#	for _edge in StoredData.edges:
#		if _edge._edge_connects_nodes_u_and_v(_edge, u, v):
#				_edge.send_ship_from_nodeA_to_nodeB(v, u)
