extends EffectCheck
# v.mark_as_iterated()
const ITERATED_COLOR = Color(0.7, 0.4, 0.2)

func _trigger_on_next_line_side_effect():
	var v: AGraphNode = StoredData.get_variable("v")
	v.modulate = ITERATED_COLOR

