extends EffectCheck
# If u.is_not_explored()

# Ask the user whether answer is true or false
func check_actions_correct() -> bool:
	# Check if the user gave the right answer
	return StoredData.v_is_explored_right_answer

# Override from EffectCheck
func effect_check_on_focused():
	ask_user()
	highlight_node()

func highlight_node():
	StoredData.get_variable("u").get_node().highlight_node()

func stop_node_highlight():
	StoredData.get_variable("u").get_node().stop_highlight_node()

func ask_user() -> void:
	# Show a popup that asks the user whether u is explored or not
	# condition is true if not explored, 
	# Popup class: UNodeIsExploredPopup
	var u = StoredData.get_variable("u").get_node()
	var u_is_explored = not if_condition_is_true(u);
	# This sets the StoredData.v_is_explored_right_answer variable
	NotificationManager.ask_user_if_graph_node_is_explored_bfs(u, u_is_explored)
	
# If u.is_not_explored()
func if_condition_is_true(u) -> bool:
	if (u in StoredData.iterated_nodes or u.selected):
		return false

	return true

# If user presses enter
# Ask the user whether this is true or false
func get_next_line() -> int:
	if StoredData.v_is_explored_right_answer:
		var u = StoredData.get_variable("u").get_node()
		if self.if_condition_is_true(u):
			return .get_next_line()  # super.get_next_line()

		stop_node_highlight()
		return .get_jump_line()
	# Else: Do not move
	return self.code_line.line_index

func reset():
	StoredData.v_is_explored_right_answer = false
