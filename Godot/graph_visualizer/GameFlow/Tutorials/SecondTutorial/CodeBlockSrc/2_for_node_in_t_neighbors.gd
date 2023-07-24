extends EffectCheck
# for u in t.neighbors:

var iteration_index : int = 0
var nodes_to_visit = []
var nodes_to_visit_assigned: bool = false

func effect_check_on_focused():
	# Assuming StoredData.world_node is SecondTutorial
	if StoredData.world_node:
		nodes_to_visit = [
			StoredData.world_node.planet2,
			StoredData.world_node.star,
			StoredData.world_node.planet3
		]
		var current_node_to_select: AGraphNode = nodes_to_visit[iteration_index]
		current_node_to_select.highlight_variable("u")


func get_max_iteration_index() -> int:
	return nodes_to_visit.size()

# In this case, for is for an i < length(v.edges())
func for_condition_is_true() -> bool:
	# If for condition is true, keep reading following lines and execute side effects
	if iteration_index < get_max_iteration_index():
		return true
	# Skip and get jump line
	return false


# Set next node
func execute_side_effect() -> void:
	# We need this condition to be true. This must have been checked previously
	# But I am adding it here anyway for code safety
	if for_condition_is_true():
		var current_node_to_select: AGraphNode = nodes_to_visit[iteration_index]
		StoredData.selectable_nodes_indexes = [current_node_to_select.index]
		iteration_index = iteration_index + 1


func get_next_line() -> int:
	if self.for_condition_is_true():
		execute_side_effect()
		return .get_next_line()  # super.get_next_line()
	else:
		return .get_jump_line()
