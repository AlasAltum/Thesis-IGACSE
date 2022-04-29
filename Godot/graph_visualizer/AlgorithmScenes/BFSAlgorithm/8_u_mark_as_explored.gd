extends EffectCheck
# u.mark_as_explored()


func check_actions_correct() -> bool:
	return true  # This is not required

func execute_side_effect() -> void:
	# mark u as explored
	var u : AGraphNode = StoredData.get_variable("u")
	u.set_selected()


func get_next_line() -> int:
	execute_side_effect()
	return .get_next_line()  # super.get_next_line()
