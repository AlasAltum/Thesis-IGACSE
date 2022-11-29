extends EffectCheck
# T.append(e)

func _trigger_on_next_line_side_effect():
	var t : SetADT = StoredData.get_variable("T")
	t.add_data(StoredData.get_variable("v"))
	t.add_data(StoredData.get_variable("w"))
	StoredData.update_views()
	StoredData.highlight_variable("T")
