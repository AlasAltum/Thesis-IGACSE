extends EffectCheck

# Make sure that user has created a queue with name q and it has the node(0). 
func check_actions_correct() -> bool:
	if StoredData.has_variable("MST"):
		if StoredData.get_variable("MST").as_string() == "[]":
			return true
	return false

func _trigger_on_next_line_side_effect() -> void:
	var e = StoredData.get_variable("e")
	StoredData.get_variable("MST").add_data(e)
	StoredData.update()
