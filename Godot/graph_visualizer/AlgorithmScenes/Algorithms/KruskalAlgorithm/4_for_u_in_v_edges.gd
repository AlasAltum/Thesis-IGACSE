extends EffectCheck
# for (Edge e in Graph.edges):

# Since this is a for loop, we would like to keep our iteration index,
# So each time this line is focused, the given value is going to be different
var iteration_index : int = 0

# set e: Edge with lowest weight not iterated yet
func execute_side_effect() -> void:
	var e = StoredData.edges[iteration_index]
	StoredData.add_variable("e", e)
	iteration_index += 1


func get_max_iteration_index() -> int:
	return StoredData.edges.size()

# In this case, for is for an i < length(v.edges())
func for_condition_is_true() -> bool:
	# If we still have edge indexes to iterate, keep the looping process
	if iteration_index < get_max_iteration_index():
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
