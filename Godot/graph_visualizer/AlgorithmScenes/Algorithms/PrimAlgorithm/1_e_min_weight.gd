extends EffectCheck
# Edge e = min(graph.edge_weights)

var min_weight: float = 9999999.9  # Simulating a high float
var min_weight_edges = []

# Get the edges with minimum weight
func effect_check_on_focused():
	for _edge in StoredData.edges:
		print(_edge.weight)
		self.min_weight = min(self.min_weight, _edge.weight)
		StoredData.min_weight = self.min_weight
	return


# Checks that the edge with minimum weight has been clicked
func check_actions_correct():
	if StoredData.get_selected_edge() != null:
		if StoredData.get_selected_edge().weight == self.min_weight:
			StoredData.add_variable("e", StoredData.get_selected_edge())
			return true
	return false
