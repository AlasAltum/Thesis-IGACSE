extends EffectCheck
# for node in t.neighbors:

var iteration_index : int = 0
var nodes_to_visit = []
var nodes_to_visit_assigned: bool = false


func get_max_iteration_index() -> int:
	return StoredData.world_node.starting_node.edges.size()

# In this case, for is for an i < length(v.edges())
func for_condition_is_true() -> bool:
	# If for condition is true, keep reading following lines and execute side effects
	if iteration_index < get_max_iteration_index():
		return true
	# Skip and get jump line
	return false


# set next node
func execute_side_effect() -> void:
	pass


func get_next_line() -> int:
	if self.for_condition_is_true():
		execute_side_effect()
		return .get_next_line()  # super.get_next_line()
	else:
		return .get_jump_line()
