extends EffectCheck
#  while (MST.size() < graph.vertices.size()):

func get_max_iteration_index() -> int:
	return StoredData.edges.size()

# In this case, for is for an i < length(v.edges())
func while_condition_is_true() -> bool:
	# while (MST.size() < graph.vertices.size()):
	if StoredData.has_variable("T"):
		var T: SetADT = StoredData.get_variable("T")
		if T.size() < StoredData.nodes.size():
			return true

	return false


func get_next_line() -> int:
	if self.while_condition_is_true():
		return .get_next_line()  # super.get_next_line()

	return .get_jump_line()
