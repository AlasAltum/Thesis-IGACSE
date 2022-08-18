extends EffectCheck
# e = min_edge_connecting(V, V-A)

var e_min_weight_edge: float = 9999999.9  # Simulating a high float


# When entering this line, identify in the backend the minimum weight edge
func effect_check_on_focused():
	for _edge in StoredData.edges:
		var _edge_is_not_selected = _edge.is_not_selected()
		if _edge_is_not_selected:
			# Case after while, it's not updating. We need to take a list of selected edges
			# and a list of edges that have not been selected
			self.e_min_weight_edge = min(self.e_min_weight_edge, _edge.weight)
			StoredData.min_weight = self.e_min_weight_edge
	return


# User needs to click the edge with minimum weight connecting V and V-A
func check_actions_correct() -> bool:
	var selected_edge = StoredData.get_selected_edge()
	if selected_edge != null:
		if selected_edge.weight == self.e_min_weight_edge:
			# TODO: selected edge is not changing in variables block, it needs update
			StoredData.add_variable("e", selected_edge)
			selected_edge.set_selected()
			return true
	return false


func reset():
	StoredData.u_is_explored_right_answer = false
