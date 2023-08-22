extends EffectCheck
# hover_mouse_on_node_0()
var node_0: AGraphNode

func effect_check_on_focused() -> void:
	node_0 = StoredData.get_node_by_index(0)

# Make sure that user has created a stack with name s and it has the node(0). 
func check_actions_correct() -> bool:
	if is_instance_valid(node_0) and node_0.mouse_hovering:
		return true

	return false
