extends EffectCheck
# v.mark_as_iterated()
const ITERATED_COLOR = Color(0.7, 0.4, 0.2)

func _trigger_on_next_line_side_effect():
	var v: NodeADT = StoredData.get_variable("v")
	var v_graph_node: AGraphNode = v.parent_node
	v_graph_node.mark_as_iterated()
