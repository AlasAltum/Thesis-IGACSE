extends EffectCheck
# if u is not a star

func restart_values_between_iterations():
	StoredData.world_node.u_is_not_a_star_correct_answer = false

func _trigger_on_next_line_side_effect():
	restart_values_between_iterations()

func effect_check_on_focused():
	# Show a popup that asks the user whether u is a star or not
	# condition is true if u is not a star
	# Popup class: NodeIsNotAStarPopup
	# Assume StoredData.world_node = SecondTutorial
	# This sets the StoredData.world_node.u_is_not_a_star_node variable
	# Normally, we would the NotificationManager singleton, but since this is a tutorial
	# and not the typical game, it is better to have a containarized logic and not add more
	# variables that are not going to be used through the game
	restart_values_between_iterations()
	# Get current u_node
	var world_node = StoredData.world_node
	var u = world_node.current_selectable_node
	world_node.u_node = u
	# Get star
	var star_node = StoredData.world_node.star
	# Check if star != current u node
	var u_is_not_a_star: bool = ( u != star_node)
	StoredData.world_node.ask_user_if_u_node_is_a_star(u_is_not_a_star)
	highlight_node()

func highlight_node():
	if StoredData.world_node and StoredData.world_node.u_node:
		StoredData.world_node.u_node.highlight_node()
		StoredData.world_node.u_node.highlight_node_with_size()

func stop_node_highlight():
	if StoredData.world_node.u_node:
		StoredData.world_node.u_node.unhighlight_node()
		StoredData.world_node.u_node.unhighlight_node_with_size()

# Ask the user whether answer is true or false
func check_actions_correct() -> bool:
	# Check if the user gave the right answer
	return StoredData.world_node.u_is_not_a_star_correct_answer


func if_condition_is_true(node):
	var star_node = StoredData.world_node.star
	return node != star_node

## If user presses enter
## Ask the user whether this is true or false
func get_next_line() -> int:
	var u = StoredData.world_node.u_node
	if self.if_condition_is_true(u):
		stop_node_highlight()
		return .get_next_line()  # super.get_next_line()

	stop_node_highlight()
	return .get_jump_line()

