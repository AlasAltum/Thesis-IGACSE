extends EffectCheck
# If Find(w) != Find(v)


func get_indexes_of_sets_with_nodes(array_of_sets: Array, node1: NodeADT, node2: NodeADT) -> Array:
	var node1_group_index: int
	var node2_group_index: int
	# array_of_sets at the begging comes in the form of:
	# [ [node0], [node1], [node2], [node3], ...] 
	# These arrays have different colors
	for array_adt in array_of_sets:
		# [ [node0], [node1], [node2], [node3], ...]
		if node1 in array_adt:
			node1_group_index = array_of_sets.find(array_adt)
		if node2 in array_adt:
			node2_group_index = array_of_sets.find(array_adt)

	return [node1_group_index, node2_group_index]


func nodes_have_same_union_find(node1: NodeADT, node2: NodeADT) -> bool:
	var c : ArrayADT = StoredData.get_variable("C")

	var tuple = get_indexes_of_sets_with_nodes(c.data, node1, node2)
	var node1_group_index = tuple[0]
	var node2_group_index = tuple[1]

	if node1_group_index == node2_group_index:
		return true

	return false

func move_node_with_set_of_max_index_to_the_set_with_min_index(array_of_sets: Array, node1: NodeADT, node2: NodeADT) -> void:
	# We try to store the nodes in the min-index-array
	var tuple = get_indexes_of_sets_with_nodes(array_of_sets, node1, node2)
	var node1_group_index = tuple[0]
	var node2_group_index = tuple[1]
	# Get min and max index of the groups
	var max_index: int = max(node1_group_index, node2_group_index)
	var min_index: int = min(node1_group_index, node2_group_index)
	# move the node with max index to the set with the node with min index
	array_of_sets[max_index].remove(node2)
	array_of_sets[min_index].append(node2)

func effect_check_on_focused():
	pass

func get_if_condition_is_true(v: NodeADT, w: NodeADT) -> bool:
	# If Find(w) != Find(v)
	return nodes_have_same_union_find(v, w)

func check_actions_correct() -> bool:
	# TODO: Add ask user question
	return true
