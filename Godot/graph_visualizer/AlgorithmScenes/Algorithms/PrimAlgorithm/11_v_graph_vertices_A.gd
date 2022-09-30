extends EffectCheck
# V = {graph.vertices} - A


# Get the list of node objects from an ArrayADT
func get_nodes_objects_from_array_adt(variable_in_stored_data: String):
	# This gets the Node ADTs, but we need the Node objects
	var nodes_in_t_data: Array = StoredData.get_variable(variable_in_stored_data).data
	# Get the node objects
	var nodes_in_t: Array = []
	for node in nodes_in_t_data:
		if not node.parent_node in nodes_in_t:
			nodes_in_t.append(node.parent_node)
	return nodes_in_t


func execute_side_effect() -> void:
	var all_nodes = StoredData.nodes
	var nodes_in_t = self.get_nodes_objects_from_array_adt("T")
	# Create set A: all nodes excepting the ones in A
	var v = SetADT.new()
	for node in all_nodes:
		v.add_data(node)
	for node_in_a in nodes_in_t:
		v.substract_data(node_in_a)
	# Until now, all nodes are of the type AGraphNode
	# We need to get their respective NodeADT
	for graph_node_index in range(v.data.size()):
		v.data[graph_node_index] = v.data[graph_node_index].adt
	StoredData.add_variable("V", v)



func get_next_line() -> int:
	self.execute_side_effect()
	return .get_next_line()  # super.get_next_line()
