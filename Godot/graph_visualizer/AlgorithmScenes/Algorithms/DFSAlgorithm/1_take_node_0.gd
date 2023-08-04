extends EffectCheck
# t = starting_node;

func effect_check_on_focused() -> void:
	var t = StoredData.nodes[0]
	t.highlight_node()


func _trigger_on_next_line_side_effect() -> void:
	var t = StoredData.nodes[0]
	StoredData.add_variable("t", t.get_adt())
	t.unhighlight_node()
