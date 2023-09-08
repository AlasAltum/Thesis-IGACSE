extends EffectCheck
# s.add(2)


func effect_check_on_focused() -> void:
	var node_two : AGraphNode = StoredData.get_node_by_index(2)
	StoredData.add_node_to_nodes_that_should_be_added_to_adt(node_two)

# Make sure that user has created a stack with name s and it has the node(0). 
func check_actions_correct() -> bool:
	if StoredData.has_variable("s"):
		if StoredData.get_variable("s").as_string() == "Stack((0), (2))":
			return true
	return false

func _show_hint_to_user():
	var node_2 : AGraphNode = StoredData.get_node_by_index(2)
	node_2.show_animation_of_R()
	# Get s label and highlight it with a looping animation
	# deactivate the animation once the user navigates to the next line
	StoredData.highlight_variable("s", true)

func _trigger_on_correct_once():
	._trigger_on_correct_once()
	StoredData.stop_highlight_variable("s")
	var node_2 : AGraphNode = StoredData.get_node_by_index(2)
	node_2.stop_animation_of_R()
