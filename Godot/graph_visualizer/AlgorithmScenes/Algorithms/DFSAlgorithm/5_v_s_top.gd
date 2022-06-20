extends EffectCheck
# v = s.top()

func check_actions_correct() -> bool:
	return true  # This is not required

func execute_side_effect() -> void:
	if StoredData.has_variable("s"):
		var stack : StackADT = StoredData.get_variable("s")
		var top_node_in_stack : AGraphNode = stack.top()
		StoredData.add_variable("v", top_node_in_stack)

func get_next_line() -> int:
	self.execute_side_effect()
	return .get_next_line()  # super.get_next_line()
