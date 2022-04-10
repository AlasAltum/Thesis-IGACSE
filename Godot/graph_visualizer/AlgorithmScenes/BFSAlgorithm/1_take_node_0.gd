# Null effect, this is just for function initializations and skip lines.
extends EffectCheck


func _ready():
	pass

static func check_actions_correct() -> bool:
	var selected_nodes = StoredData.get_selected_nodes()
	if selected_nodes.size() == 1 && selected_nodes[0].index == 0:
		StoredData.add_variable("t", "Node(index=0)")
		return true
	return false  
