extends EffectCheck
# MST = [e]

# Make sure that user has created a queue with name q and it has the node(0). 
func check_actions_correct() -> bool:
	if StoredData.has_variable("MST"):
		var mst_str : String = StoredData.get_variable("MST").as_string()
		if "[" in mst_str and "]" in mst_str:
			return true
	return false


func _trigger_on_next_line_side_effect() -> void:
	var e: EdgeADT = StoredData.get_variable("e")
	var mst = StoredData.get_variable("MST")
	mst.add_data(e)
	StoredData.adt_mediator.update()
	StoredData.highlight_variable("MST")
