extends EffectCheck
# If u.is_not_explored()

# Ask the user whether answer is true or false
func check_actions_correct() -> bool:
	# Check if the user gave the right answer
	return StoredData.u_is_explored_right_answer

# Override from EffectCheck
func effect_check_on_focused():
	ask_user()

func ask_user() -> void:
	# Show a popup that asks the user whether u is explored or not
	# condition is true if not explored, 
	var u = StoredData.get_variable("u").get_node()
	var u_is_explored = not if_condition_is_true(u);
	NotificationManager.ask_user_if_graph_node_is_explored(u, u_is_explored)
	# This sets the StoredData.u_is_explored_right_answer variable
	
# If u.is_not_explored()
func if_condition_is_true(u) -> bool:
	if (u in StoredData.iterated_nodes):
		return false

	return true

# If user presses enter
# Ask the user whether this is true or false
func get_next_line() -> int:
	if StoredData.u_is_explored_right_answer:
		var u = StoredData.get_variable("u").get_node()
		if self.if_condition_is_true(u):
			return .get_next_line()  # super.get_next_line()

		return .get_jump_line()
	# Else: Do not move
	return self.code_line.line_index

func reset():
	StoredData.u_is_explored_right_answer = false
