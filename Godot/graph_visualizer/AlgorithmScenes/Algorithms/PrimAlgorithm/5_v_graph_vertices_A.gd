extends EffectCheck
# Set A = {graph.vertices} - T


# Get the list of node objects from a Set
func get_nodes_objects_from_set(variable_in_stored_data: String):
	# This gets the Node ADTs, but we need the Node objects
	var nodes_in_t_data: Array = StoredData.get_variable(variable_in_stored_data).data
	# Get the node objects
	var nodes_in_t: Array = []
	for node in nodes_in_t_data:
		var _node = node
		nodes_in_t.append(node)
	return nodes_in_t


func execute_side_effect() -> void:
	var all_nodes = StoredData.nodes
	var nodes_in_t = self.get_nodes_objects_from_set("T")
	# Generate Set V
	var a = SetADT.new()
	# We work only with node ADTss
	# Set V = {graph.vertices}
	for node in all_nodes:
		a.add_data(node)
	# Set V = {graph.vertices} - T
	for node_in_t in nodes_in_t:
		a.substract_data(node_in_t.parent_node)
	# But until now we are only having the raw nodes
	# We want to work with these ADTs, because the raw nodes
	# Contain other type of logic.
	# With this loop we can convert the raw nodes to its adt forms
	for index in range(a.data.size()):
		a.data[index] = a.data[index].adt
	StoredData.add_variable("A", a)


func get_next_line() -> int:
	self.execute_side_effect()
	return .get_next_line()  # super.get_next_line()
