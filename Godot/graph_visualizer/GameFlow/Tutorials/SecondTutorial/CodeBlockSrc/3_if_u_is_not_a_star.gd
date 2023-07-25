extends EffectCheck
# if u is not a star

func effect_check_on_focused():
	# Show a popup that asks the user whether u is a star or not
	# condition is true if u is not a star
	# Popup class: NodeIsNotAStarPopup
	# Assume StoredData.world_node = SecondTutorial
	# This sets the StoredData.world_node.u_is_not_a_star_node variable
	# Normally, we would the NotificationManager singleton, but since this is a tutorial
	# and not the typical game, it is better to have a containarized logic and not add more
	# variables that are not going to be used through the game
	var u = StoredData.world_node.current_selectable_node
	var star_node = StoredData.world_node.star
	StoredData.world_node.u_node = u
	var u_is_not_a_star: bool = ( u != star_node)
	StoredData.world_node.ask_user_if_u_node_is_a_star(u_is_not_a_star)
	highlight_node()



func highlight_node():
	if StoredData.world_node.u_node:
		StoredData.world_node.u_node.highlight_node()

func stop_node_highlight():
	if StoredData.world_node.u_node:
		StoredData.world_node.u_node.stop_highlight_node()


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
		return .get_next_line()  # super.get_next_line()

	stop_node_highlight()
	return .get_jump_line()

