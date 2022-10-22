extends EffectCheck
# If Find(w) != Find(v)


func check_actions_correct() -> bool:
	# TODO: Add ask user question
	return StoredData.find_w_unequal_find_v_correct_answer

func reset():
	StoredData.find_w_unequal_find_v_correct_answer = false


func effect_check_on_focused():
	var v: NodeADT = StoredData.get_variable("v")
	var w: NodeADT = StoredData.get_variable("w")

	var find_w_unequal_find_v: bool = self.get_if_condition_is_true(v, w)  # Find(w) != Find(v)
	NotificationManager.ask_user_if_find_w_unequal_find_v(find_w_unequal_find_v)


func get_if_condition_is_true(v: NodeADT, w: NodeADT) -> bool:
	# If Find(w) != Find(v)
	return nodes_have_same_union_find(v, w)

func nodes_have_same_union_find(node1: NodeADT, node2: NodeADT) -> bool:
	var c : ArrayADT = StoredData.get_variable("C")

	var tuple = get_indexes_of_sets_with_nodes(c.data, node1, node2)
	var node1_group_index = tuple[0]
	var node2_group_index = tuple[1]

	if node1_group_index == node2_group_index:
		return true

	return false

func get_indexes_of_sets_with_nodes(array_of_sets: Array, node1: NodeADT, node2: NodeADT) -> Array:
	var node1_group_index: int
	var node2_group_index: int
	# array_of_sets at the beginning comes in the form of:
	# [ [node0], [node1], [node2], [node3], ...] 
	# These arrays have different colors
	for array_adt in array_of_sets:
		# [ [node0], [node1], [node2], [node3], ...]
		if node1 in array_adt:
			node1_group_index = array_of_sets.find(array_adt)
		if node2 in array_adt:
			node2_group_index = array_of_sets.find(array_adt)

	return [node1_group_index, node2_group_index]
