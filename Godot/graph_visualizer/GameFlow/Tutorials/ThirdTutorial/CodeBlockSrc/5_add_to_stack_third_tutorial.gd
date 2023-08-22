extends EffectCheck
# s.add(t)

const HINT_TEXT = "TUTORIAL_3_HINT_2"
# """Press W and S to move the current selected variable. Select the stack S by checking that the line "S: stack()" is green and moving. After selecting the stack S, hover the mouse on the planet 0 and press r/R. The selected variable will be shown on the bottom right panel. Check it after pressing r/R!

func effect_check_on_focused() -> void:
	var t : AGraphNode = StoredData.get_variable("t").get_node()
	StoredData.add_node_to_nodes_that_should_be_added_to_adt(t)
	if not is_instance_valid(StoredData.world_node):
		printerr("Not valid world node instance")
		return
	var dialogue_displayer = StoredData.world_node.dialogue_displayer
	dialogue_displayer.show_single_text(HINT_TEXT)

# Make sure that user has created a stack with name s and it has the node(0). 
func check_actions_correct() -> bool:
	if StoredData.has_variable("s"):
		if StoredData.get_variable("s").as_string() == "Stack((0))":
			return true
	return false

func _trigger_on_next_line_side_effect():
	var dialogue_displayer = StoredData.world_node.dialogue_displayer
	dialogue_displayer.close_single_text()
