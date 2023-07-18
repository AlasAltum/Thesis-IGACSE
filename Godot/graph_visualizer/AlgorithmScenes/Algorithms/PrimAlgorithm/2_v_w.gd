extends EffectCheck
# (v, w) = nodes_connected_with(e)

var v
var w 


func effect_check_on_focused():
	var _edge = StoredData.get_variable("e")
	var v_w = _edge.get_connecting_nodes()
	v = v_w[0]
	w = v_w[1]
	StoredData.selectable_nodes_indexes.append(v.index)
	StoredData.selectable_nodes_indexes.append(w.index)

func check_actions_correct() -> bool:
	if (
		StoredData.has_variable("e") and
		v in StoredData.get_selected_nodes() and
		w in StoredData.get_selected_nodes()
	):
		return true
	return false

func _trigger_on_next_line_side_effect():
	StoredData.add_variable("v", v)
	StoredData.add_variable("w", w)
