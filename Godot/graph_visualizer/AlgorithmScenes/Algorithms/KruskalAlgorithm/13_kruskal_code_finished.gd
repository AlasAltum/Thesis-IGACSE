extends EffectCheck
# finish code
var message: String = "Kruskal Finished"


# TODO: Add notification
func effect_check_on_focused() -> void:
	NotificationManager.on_code_finished_popup(message)
	var main_node: GraphManager = StoredData.get_nodes_in_group("Main")[0]
	# Mark level as finished
	StoredData.finished_levels[main_node.level_name] = true

func check_actions_correct() -> bool:
	return true
