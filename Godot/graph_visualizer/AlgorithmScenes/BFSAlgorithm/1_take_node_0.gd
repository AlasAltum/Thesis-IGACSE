extends EffectCheck


func _ready():
	pass

# when calling the new function
func _init():
	code_line = null


func check_actions_correct() -> bool:
	var selected_nodes = StoredData.get_selected_nodes()
	if selected_nodes.size() == 1 && selected_nodes[0].index == 0:
		StoredData.add_variable("t", selected_nodes[0])
		return true
	return false  

func get_next_line() -> int:
	return code_line.line_index + 1
