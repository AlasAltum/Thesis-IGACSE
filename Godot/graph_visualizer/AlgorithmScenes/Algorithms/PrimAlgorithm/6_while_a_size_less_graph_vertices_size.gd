extends EffectCheck
#    while (A.size() < graph.vertices.size()):


# In this case, A.size() < graph.vertices.size()
func for_condition_is_true() -> bool:
	var a_set : SetADT = StoredData.get_variable("T")
	var a_size = a_set.data.size()
	var graph_size = StoredData.nodes.size()
	# If while condition is true, keep reading following lines
	if  a_size < graph_size:
		return true
	# Skip and get jump line
	return false


# Next line if the condition is true, else, jump
func get_next_line() -> int:
	if self.for_condition_is_true():
		return .get_next_line()  # super.get_next_line()
	return .get_jump_line()
