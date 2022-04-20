extends EffectCheck
# while q.is_not_empty()

func check_actions_correct() -> bool:
	return true  # This is not required

# Considering that it is a while, it should return
# the next line if the cicle continues, or jump to the jump line
# elsewise
func get_next_line() -> int:
	if StoredData.has_variable("q"):
		# NEXT LINE
		if "Queue(Node(" in StoredData.heap_dictionary["q"].as_variable():
#			StoredData.execute_jump()
			return .get_next_line()  # super.get_next_line()

		# JUMP
		else:
			return .get_jump_line()

	return -1
