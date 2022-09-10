extends EffectCheck
# if (len(C) == 1)


# Considering that it is a while, it should return
# the next line if the cicle continues, or jump to the jump line
func get_next_line() -> int:
	# If the while condition is true, keep with the next line
	if self.compute_if_length_c_is_1():
		return .get_jump_line()  # super.get_next_line()

	# elsewise, just jump to the end while line
	else:
		return .get_next_line()


# Override from EffectCheck
func effect_check_on_focused():
	ask_user()

func ask_user() -> void:
	# Show a popup that asks the user wheter len(C) is 1
	var length_c_is_1: bool = self.compute_if_length_c_is_1()
	NotificationManager.ask_user_if_lenth_c_is_1(length_c_is_1)


func compute_if_length_c_is_1() -> bool:
	var c: ArrayADT = StoredData.get_variable("C")
	return c.size() == 1

# Ask the user whether answer is true or false
func check_actions_correct() -> bool:
	return StoredData.length_c_is_one_correct_answer

# Set the variable to false so the user may not skip this instruction	
func reset():
	StoredData.length_c_is_one_correct_answer = false
