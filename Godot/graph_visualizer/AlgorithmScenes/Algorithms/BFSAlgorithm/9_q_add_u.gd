extends EffectCheck
# q.add(u)

func effect_check_on_focused():
	var u = StoredData.get_variable("u").get_node()
	StoredData.add_node_to_nodes_that_should_be_added_to_adt(u)
	StoredData.allow_nodes_dragging = true  # To allow also dragging nodes


func check_actions_correct() -> bool:
	if StoredData.has_variable("q") and StoredData.has_variable("u"):
		var u: AGraphNode = StoredData.get_variable("u").get_node()
		var u_as_string: String = u.as_string()
		# It will show Queue() if it is empty. The player must add the u node
		if u_as_string in StoredData.get_variable("q").as_string():
			StoredData.allow_nodes_dragging = false
			u.unhighlight_node()
			return true
	return false

func _trigger_on_next_line_side_effect():
	# Unhighlight the highlighted edge
	StoredData.set_highlighted_edge(null)

func _show_hint_to_user():
	var u : AGraphNode = StoredData.get_variable("u").get_node()
	u.show_animation_of_R()
	# Get s label and highlight it with a looping animation
	# deactivate the animation once the user navigates to the next line
	StoredData.highlight_variable("q", true)

func _trigger_on_correct_once():
	._trigger_on_correct_once()
	StoredData.stop_highlight_variable("q")
	var u : AGraphNode = StoredData.get_variable("u").get_node()
	u.stop_animation_of_R()
