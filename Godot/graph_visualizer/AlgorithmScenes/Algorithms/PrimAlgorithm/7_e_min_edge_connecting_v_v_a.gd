extends EffectCheck
# e = min_edge_connecting(V, V-A)

const MAX_WEIGHT: float = 9999999.9
var e_min_weight_edge: float = MAX_WEIGHT  # Simulating a high float
var selected_edge


func reset() -> void:
	self.e_min_weight_edge = 9999999.9  # Simulating a high float

# When entering this line, identify in the backend the minimum weight edge
# That is not selected
func effect_check_on_focused():
	for _edge in StoredData.edges:
		if not _edge in StoredData.selected_edges:
			# Case after while, it's not updating. We need to take
			# a list of selected edges and a list of edges that have not been selected
			self.e_min_weight_edge = min(self.e_min_weight_edge, _edge.weight)
	return


# User needs to click the edge with minimum weight connecting V and V-A
func check_actions_correct() -> bool:
	# TODO: Now we have to get the minimum weight that connects the two sets
	selected_edge = StoredData.get_selected_edge()
	if selected_edge and selected_edge.weight == self.e_min_weight_edge:
		# TODO: selected edge is not changing in variables block, it needs update
		StoredData.add_variable("e", selected_edge)
		selected_edge.set_selected()
		return true
	return false

func _trigger_on_next_line_side_effect():
	selected_edge.set_selected()
	StoredData.selected_edges.append(selected_edge)

