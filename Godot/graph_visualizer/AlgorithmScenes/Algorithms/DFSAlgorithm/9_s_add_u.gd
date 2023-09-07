extends EffectCheck
# s.add(u)


func effect_check_on_focused() -> void:
	var u : AGraphNode = StoredData.get_variable("u").get_node()
	StoredData.add_node_to_nodes_that_should_be_added_to_adt(u)
	var v : AGraphNode = StoredData.get_variable("v").get_node()
	u.visited_from_node = v

# check that node U is inside stack S
func check_actions_correct() -> bool:
	if StoredData.has_variable("s") and StoredData.has_variable("u"):
		var u: AGraphNode = StoredData.get_variable("u").get_node()
		var u_as_string: String = u.as_string()
		# It will show Stack() if it is empty. The player must add the u node
		# in order to show u_as_string inside the string of s
		if u_as_string in StoredData.get_variable("s").as_string():
			u.unhighlight_node()
			return true
	return false

func _show_hint_to_user():
	var u : AGraphNode = StoredData.get_variable("u").get_node()
	u.show_animation_of_R()
	# Get s label and highlight it with a looping animation
	# deactivate the animation once the user navigates to the next line
	StoredData.highlight_variable("s", true)

func _trigger_on_correct_once():
	._trigger_on_correct_once()
	StoredData.stop_highlight_variable("s")
	var u : AGraphNode = StoredData.get_variable("u").get_node()
	u.stop_animation_of_R()

