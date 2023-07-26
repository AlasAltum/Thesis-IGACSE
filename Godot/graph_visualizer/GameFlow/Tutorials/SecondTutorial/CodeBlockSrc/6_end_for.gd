extends EffectCheck
# endfor;

# it will always jump to the for.
func get_next_line() -> int:
	return .get_jump_line()

func get_jump_line() -> int:
	return code_line.jump_index

# Erase highlight of u_node
func effect_check_on_focused() -> void:
	var u : AGraphNode = StoredData.world_node.u_node
	u.unhighlight_variable()
