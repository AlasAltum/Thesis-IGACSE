extends EffectCheck
#       v.click_node()

func effect_check_on_focused():
	var v_node = StoredData.get_variable("v").get_node()
	StoredData.selectable_nodes_indexes.append(v_node.index)

func check_actions_correct() -> bool:
	# Get node v. if Node v is selected return true
	var v_node = StoredData.get_variable("v").get_node()
	if StoredData.world_node and v_node and v_node.selected:
		return true
	return false

func _trigger_on_correct_once():
	var t_node = StoredData.get_variable("t").get_node()
	var v_node = StoredData.get_variable("v").get_node()
	for _edge in StoredData.edges:
		if _edge_connects_nodes_u_and_v(_edge, t_node, v_node):
			_edge.send_ship_from_nodeA_to_nodeB(t_node, v_node)


func _edge_connects_nodes_u_and_v(_edge, u, v):
	if (_edge.joint_end1 == u and _edge.joint_end2 == v) or \
		(_edge.joint_end1 == v and _edge.joint_end2 == u):
		return true
	return false
