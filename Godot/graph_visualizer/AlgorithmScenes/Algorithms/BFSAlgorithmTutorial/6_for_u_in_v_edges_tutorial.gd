extends EffectCheck
# for (Node u: v.edges()):

var iteration_index : int = 0

# set u as node
func execute_side_effect() -> void:
	var v : AGraphNode = StoredData.get_variable("v").get_node()
	# v.edges[iteration_index] is a pair [node_index, weight]
	var u_index : int = v.edges[iteration_index][0]
	var u : AGraphNode = StoredData.nodes[u_index]
	# Get edge between node v and u and highlight it. This works because our graph
	# is not a multigraph, it allows only one edge between two nodes
	var edge_between_u_and_v = StoredData.get_edge_between_nodes(u, v)
	StoredData.set_highlighted_edge(edge_between_u_and_v)
	StoredData.add_variable("u", u.get_adt())
	iteration_index += 1


func get_max_iteration_index(v: AGraphNode) -> int:
	return v.edges.size()

# In this case, for is for an i < length(v.edges())
func for_condition_is_true() -> bool:
	var v : AGraphNode = StoredData.get_variable("v").get_node()
	# If for condition is true, keep reading following lines and execute side effects
	if iteration_index < get_max_iteration_index(v):
		return true
	# Skip and get jump line
	return false


func get_next_line() -> int:
	if self.for_condition_is_true():
		execute_side_effect()
		return .get_next_line()  # super.get_next_line()

	# Jump and erase u node
	if StoredData.has_variable("u"):
		StoredData.erase_variable("u")
		# Reset iteration index to 0
		iteration_index = 0

	return .get_jump_line()
