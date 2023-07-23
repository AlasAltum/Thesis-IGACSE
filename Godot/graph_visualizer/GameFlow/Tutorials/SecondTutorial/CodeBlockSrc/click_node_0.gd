extends EffectCheck

# Press Enter
var side_effect_has_been_executed : bool = false
var helping_timer: Timer
var node_0: AGraphNode

func effect_check_on_focused() -> void:
	# Set the node 0 that must   be selected
	if StoredData.world_node: # : SecondTutorial
		for _node in StoredData.nodes:
			if is_instance_valid(_node) and _node.index == 0:
				node_0 = _node
				StoredData.selectable_nodes_indexes.append(0)
				break

#func _trigger_on_next_line_side_effect():
#	if node_0:


func check_actions_correct() -> bool:
	if node_0 and node_0.selected:
		if not side_effect_has_been_executed:
			side_effect_has_been_executed = true
			node_0.highlight_variable("t")
			node_0.on_ship_arrived() # Show the base
		return true
	return false
