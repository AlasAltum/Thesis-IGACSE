extends EffectCheck
# If u.is_not_explored()

func check_actions_correct() -> bool:
	return true  # This is not required

func execute_side_effect() -> void:
	pass

# If u.is_not_explored()
func if_condition_is_true() -> bool:
	var u : AGraphNode = StoredData.get_variable("u")
	if (not u in StoredData.get_selected_nodes()):
		return true
	return false

func get_next_line() -> int:
	if self.if_condition_is_true():
		execute_side_effect()
		return .get_next_line()  # super.get_next_line()

	return .get_jump_line()
