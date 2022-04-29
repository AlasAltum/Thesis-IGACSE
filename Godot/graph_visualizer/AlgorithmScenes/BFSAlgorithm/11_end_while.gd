extends EffectCheck
# endwhile;

# There is no check for this line
func check_actions_correct() -> bool:
	return true

# it will always jump to the while.
# The for line may jump if its condition is not meet
func get_next_line() -> int:
	return .get_jump_line()
