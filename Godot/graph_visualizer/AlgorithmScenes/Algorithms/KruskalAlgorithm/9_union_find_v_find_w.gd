extends EffectCheck


func check_actions_correct() -> bool:
	return true

func get_indexes_of_sets_with_nodes(array_of_sets: Array, node1: NodeADT, node2: NodeADT) -> Array:
	var node1_group_index: int
	var node2_group_index: int
	# array_of_sets at the begging comes in the form of:
	# [ [node0], [node1], [node2], [node3], ...] 
	# These arrays have different colors
	for array_adt in array_of_sets:
		# [ [node0], [node1], [node2], [node3], ...]
		if node1 in array_adt.data:
			node1_group_index = array_of_sets.find(array_adt)
		if node2 in array_adt.data:
			node2_group_index = array_of_sets.find(array_adt)

	return [node1_group_index, node2_group_index]


func move_node_with_set_of_max_index_to_the_set_with_min_index(array_of_sets: Array, node1: NodeADT, node2: NodeADT) -> void:
	# We try to store the nodes in the min-index-array
	var tuple = get_indexes_of_sets_with_nodes(array_of_sets, node1, node2)
	var node1_group_index = tuple[0]
	var node2_group_index = tuple[1]
	# Get min and max index of the groups
	var min_index: int = min(node1_group_index, node2_group_index)
	var max_index: int = max(node1_group_index, node2_group_index)
	# move the nodes in the max index set to the set with min index
	var set_to_remove: Array = array_of_sets[max_index].data
	for _node in set_to_remove:
		array_of_sets[max_index].erase(_node)
		array_of_sets[min_index].append(_node)
	# Set is now empty, remove it
	array_of_sets.remove(max_index)

func _trigger_on_next_line_side_effect():
	# make a union between v and w
	var v : NodeADT = StoredData.get_variable("v")
	var w : NodeADT = StoredData.get_variable("w")
	var c : ArrayADT = StoredData.get_variable("C")
	if c and v and w:
		move_node_with_set_of_max_index_to_the_set_with_min_index(c.data, v, w)
	
