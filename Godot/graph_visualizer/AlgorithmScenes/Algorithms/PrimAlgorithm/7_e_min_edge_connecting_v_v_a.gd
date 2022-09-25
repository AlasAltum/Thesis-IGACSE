extends EffectCheck
# e = min_edge_connecting(A, T)

const MAX_WEIGHT: float = 9999999.9
var e_min_weight_edge: float = MAX_WEIGHT  # Simulating a high float
var selected_edge


func reset() -> void:
	self.e_min_weight_edge = 9999999.9  # Simulating a high float
	get_min_weight_edge_between_sets_A_and_T()

# Get the list of node objects from a SetADT
func get_nodes_in_ADT(ADT_name: String) -> Array:
	var nodes_in_adt: Array = []
	var nodes_in_adt_data: Array = StoredData.get_variable(ADT_name).data
	# Get the node objects
	for node in nodes_in_adt_data:
		if not node in nodes_in_adt:
			nodes_in_adt.append(node)
	return nodes_in_adt

# When entering this line, identify in the backend the minimum weight edge
# That is not selected
func effect_check_on_focused():
	get_min_weight_edge_between_sets_A_and_T()

func get_min_weight_edge_between_sets_A_and_T():
	# get_edge_between_sets_A_and_T
	var nodes_in_a = self.get_nodes_in_ADT("A")  # TODO: A is not using an adt, it is seting a GraphNode
	var nodes_in_t = self.get_nodes_in_ADT("T")

	for _edge in StoredData.edges:
		if not _edge in StoredData.selected_edges:
			if edge_is_connecting_a_node_between_sets(_edge, nodes_in_a, nodes_in_t):
				consider_edge_for_minimum_weight(_edge)

# True if the given edge would join the two arrays
func edge_is_connecting_a_node_between_sets(_edge, nodes_array_1: Array, nodes_array_2: Array) -> bool:
	var node_a = _edge.joint_end1
	var node_b = _edge.joint_end2
	var possibility_1: bool = node_a.adt in nodes_array_1 and node_b.adt in nodes_array_2
	var possibility_2: bool = node_a.adt in nodes_array_2 and node_b.adt in nodes_array_1
	return possibility_1 or possibility_2

func consider_edge_for_minimum_weight(current_edge):
	if not current_edge in StoredData.selected_edges:
		if current_edge.weight <= self.e_min_weight_edge:
			self.e_min_weight_edge = current_edge.weight
			return true
	return false

# User needs to click the edge with minimum weight connecting V and T
func check_actions_correct() -> bool:
	# TODO: Now we have to get the minimum weight that connects the two sets
	get_min_weight_edge_between_sets_A_and_T()
	selected_edge = StoredData.get_selected_edge()
	if selected_edge and selected_edge.weight == self.e_min_weight_edge:
		# TODO: selected edge is not changing in variables block, it needs update
		StoredData.add_variable("e", selected_edge)
		selected_edge.set_selected()
		return true
	return false

func _trigger_on_next_line_side_effect():
	self.reset()
	selected_edge.set_selected()
	StoredData.selected_edges.append(selected_edge)

