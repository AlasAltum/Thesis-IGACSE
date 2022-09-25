extends EffectCheck
# Edge e = min(graph.edge_weights)

var min_weight: float = 9999999.9  # Simulating a high float
var selected_edge

# Get the edges with minimum weight
func effect_check_on_focused():
	for _edge in StoredData.edges:
		self.min_weight = min(self.min_weight, _edge.weight)
	return


func check_actions_correct() -> bool:
	selected_edge = StoredData.get_selected_edge()
	if selected_edge and selected_edge.weight == self.min_weight:
		StoredData.add_variable("e", selected_edge)
		selected_edge.set_selected()
		return true
	return false

func _trigger_on_next_line_side_effect():
	StoredData.add_variable("e", selected_edge)
	selected_edge.set_selected()
	StoredData.selected_edges.append(selected_edge)
