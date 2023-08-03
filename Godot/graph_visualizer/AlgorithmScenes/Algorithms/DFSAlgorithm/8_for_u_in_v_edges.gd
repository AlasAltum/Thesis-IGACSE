extends EffectCheck
# for (Node u: v.non_explored_neighbors()):
var iteration_index : int = 0



func get_next_line() -> int:
	# If we have to keep adding neighbors of the node v
	if self.for_condition_is_true():
		execute_side_effect()
		return .get_next_line()  # super.get_next_line()

	# If we are here, we have already explored all neighbors of v which are not explored
	# So we erase the variable u, that will be generated the next time this loop is executed
	# and we reset the iteration index. Also, jump out of the for scope in code.
	StoredData.erase_variable("u")
	iteration_index = 0
	return .get_jump_line()


# In this case, for is for an i < length(v.edges())
func for_condition_is_true() -> bool:
	var v : AGraphNode = StoredData.get_variable("v").get_node()
	# If for condition is true, keep reading following lines and execute side effects
	if iteration_index < get_non_explored_neighbors(v).size():
		return true
	# Skip and get jump line
	return false

func get_max_iteration_index(v: AGraphNode) -> int:
	return v.edges.size()


func get_neighbors(v_node: AGraphNode) -> Array: # Array[AGraphNode]
	var u_index: int = -1
	var v_neighbors : Array = []
	var u : AGraphNode = null
	for _edge in v_node.edges:
		# _edges in this case are tuples of the form [index, weight], we just need the index
		u_index = _edge[0]
		v_neighbors.append(StoredData.nodes[u_index])

	return v_neighbors

func get_not_explored_nodes_in_array(array_of_nodes: Array) -> Array:
	var ret = []
	for _node in array_of_nodes:
		if not _node.selected:
			ret.append(_node)
	return ret

func get_non_explored_neighbors(v: AGraphNode) -> Array:
	var neighbors = get_neighbors(v)
	return get_not_explored_nodes_in_array(neighbors)


# set u as node. Executed only if the for condition is true
func execute_side_effect() -> void:
	var v : AGraphNode = StoredData.get_variable("v").get_node()
	var non_explored_neighbors = get_non_explored_neighbors(v)

	# v.edges[iteration_index] is a pair [node_index, weight]
#	var new_u : AGraphNode  = new_get_next_u_node()
	# We will try to skip nodes that have already been explored
	# to avoid trying to come back. The if after this for stops that
	# process, but it is boring for the user, so we will obscurely avoid it
	var u:  AGraphNode = non_explored_neighbors[self.iteration_index]
#	if new_u != u:
#		breakpoint
#		new_u  = new_get_next_u_node()
#		u  = get_next_u_node()

	StoredData.add_variable("u", u.get_adt())
	# Get Edge between nodes v and u and highlight the edge and u
	var edge_between_u_and_v = StoredData.get_edge_between_nodes(u, v)
	StoredData.set_highlighted_edge(edge_between_u_and_v)
	u.highlight_node()
	iteration_index += 1



func get_next_u_node() -> AGraphNode:
	var u_index : int = 0
	var u : AGraphNode = null
	var first_u: AGraphNode = null
	var first_u_already_chosen: bool = false
	var loop_broken: bool = true
	var v : AGraphNode = StoredData.get_variable("v").get_node()
	# There are basically two cases:
	# 1) Our u node was not explored or iterated and just return it
	# 2) All nodes were explored or iterated, so we just return the first one 
	while true:
		# Make sure we do not get out of the array
		if iteration_index >= v.edges.size():
			loop_broken = true
			break

		u_index = v.edges[iteration_index][0]

		# Make sure we do not get out of the array
		if u_index >= StoredData.nodes.size(): 
			loop_broken = true
			break
	
		u = StoredData.nodes[u_index]
		# If we have a break because all nodes were explored or iterated
		# return the first u node
		if not first_u_already_chosen:
			first_u = u

		iteration_index += 1
		# This makes sure our u was not explored
		if not u.is_iterated_or_explored():
			break

	# When already visited all neighbors of v
	if loop_broken:
		return first_u

	return u






