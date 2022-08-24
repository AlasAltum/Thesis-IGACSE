extends EffectCheck
# Set V = {graph.vertices} - A


# Get the list of node objects from an ArrayADT
func get_nodes_objecets_from_array_adt(variable_in_stored_data: String):
	# This gets the Node ADTs, but we need the Node objects
	var nodes_in_t_data: Array = StoredData.get_variable(variable_in_stored_data).data
	# Get the node objects
	var nodes_in_t: Array = []
	for node in nodes_in_t_data:
		nodes_in_t.append(node.parent_node)
	return nodes_in_t


func execute_side_effect() -> void:
	var v = SetADT.new()
	var all_nodes = StoredData.nodes
	for node in all_nodes:
		v.add_data(node)
	var nodes_in_t = self.get_nodes_objecets_from_array_adt("T")
	for node_in_t in nodes_in_t:
		v.substract_data(node_in_t)
	StoredData.add_variable("V", v)


func get_next_line() -> int:
	self.execute_side_effect()
	return .get_next_line()  # super.get_next_line()
