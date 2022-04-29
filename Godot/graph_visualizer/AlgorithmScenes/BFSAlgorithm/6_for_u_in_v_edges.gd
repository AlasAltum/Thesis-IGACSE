extends EffectCheck
# for (Edge u: v.edges()):
var iteration_index : int = 0


func check_actions_correct() -> bool:
	return true  # This is not required

func execute_side_effect() -> void:
	var v : AGraphNode = StoredData.get_variable("v")

	# TODO: Fix, u must be a AGraphNode
	# v.edges[iteration_index] is a pair [node_index, weight]
	# Get node_index

	# Get nodes that have not been selected

	var u_index : int = v.edges[iteration_index][0]
	var u : AGraphNode = StoredData.nodes[u_index]
	iteration_index += 1
	StoredData.add_variable("u", u)

#	while ( true ):
#		if  iteration_index >= get_max_iteration_index(v):
#			break
#
#		self.iteration_index += 1
#
#		if u.selected == false:
#			StoredData.add_variable("u", u)
#			break

func get_max_iteration_index(v: AGraphNode) -> int:
	return v.edges.size()

func for_condition_is_true() -> bool:
	var v : AGraphNode = StoredData.get_variable("v")
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
	return .get_jump_line()
