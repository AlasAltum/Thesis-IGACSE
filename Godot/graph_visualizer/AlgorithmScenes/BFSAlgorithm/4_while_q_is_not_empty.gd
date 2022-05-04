extends EffectCheck
# while q.is_not_empty()

# Ask the user whether answer is true or false
func check_actions_correct() -> bool:
	return StoredData.q_is_empty_right_answer  # This is not required

func while_condition_is_true():
	return "Queue(Node(" in StoredData.heap_dictionary["q"].as_string()

# Considering that it is a while, it should return
# the next line if the cicle continues, or jump to the jump line
# elsewise
func get_next_line() -> int:
	if StoredData.has_variable("q"):
		# If the while condition is true, keep with the next line
		if self.while_condition_is_true():
			return .get_next_line()  # super.get_next_line()

		# elsewise, just jump to the end while line
		else:
			return .get_jump_line()

	# Else: Do not move if the user has not answered correctly
	return self.code_line.line_index

# Override from EffectCheck
func effect_check_on_focused():
	ask_user()

func ask_user() -> void:
	# Show a popup that asks the user whether q is empty or not
	# While condition is true when Q is NOT empty, therefore
	# We put a not before, so it is easier to think of
	var q_is_empty : bool = self.while_condition_is_true()
	StoredData.ask_user_if_queue_is_empty(q_is_empty)

# Set the variable to false so the user may not skip this instruction	
func reset():
	StoredData.q_is_empty_right_answer = false
