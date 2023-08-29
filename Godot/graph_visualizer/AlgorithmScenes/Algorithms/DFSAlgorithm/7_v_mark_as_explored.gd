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

func _trigger_on_correct_once():
	var v : AGraphNode = StoredData.get_variable("v").get_node()
	# The first time we should skip sending the ship from node v to u
	if v == StoredData.get_variable("t").get_node():
		v.select_node()
		return

	if is_instance_valid(v.visited_from_node):
		send_ship_from_node_A_to_node_B(v.visited_from_node, v)
	

func send_ship_from_node_A_to_node_B(node_A, node_B):
	for _edge in StoredData.edges:
		if _edge.edge_connects_nodes_u_and_v(node_A, node_B):
			_edge.send_ship_from_nodeA_to_nodeB(node_A, node_B)

		
		 
#   This is what should happen, but we do not have access to the u variable at this point
#	var u : AGraphNode = StoredData.get_variable("u").get_node() 
#	for _edge in StoredData.edges:
#		if _edge._edge_connects_nodes_u_and_v(_edge, u, v):
#				_edge.send_ship_from_nodeA_to_nodeB(v, u)
