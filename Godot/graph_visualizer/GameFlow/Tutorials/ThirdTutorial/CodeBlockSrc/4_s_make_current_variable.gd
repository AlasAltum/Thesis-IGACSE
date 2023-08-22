extends EffectCheck
# s.make_current_variable()
var stack_label

const HINT_TEXT = "TUTORIAL_3_HINT_1"

func effect_check_on_focused() -> void:
	var t : AGraphNode = StoredData.get_variable("t").get_node()

	if not is_instance_valid(StoredData.world_node):
		printerr("Not valid world node instance")
		return
	var dialogue_displayer = StoredData.world_node.dialogue_displayer
	dialogue_displayer.show_single_text(HINT_TEXT)


func check_actions_correct() -> bool:
	# Make sure s is the current variable
	return StoredData.get_selected_variable_name() == "s"
