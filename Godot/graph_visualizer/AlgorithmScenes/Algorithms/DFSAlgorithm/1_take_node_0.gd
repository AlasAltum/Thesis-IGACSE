extends EffectCheck
# t = starting_node;
var node_0: AGraphNode
var helping_timer: Timer

func effect_check_on_focused() -> void:
	var t = StoredData.nodes[0]
	t.highlight_node()

	if StoredData.world_node: # : SecondTutorial
		for _node in StoredData.nodes:
			if is_instance_valid(_node) and _node.index == 0:
				node_0 = _node
				StoredData.selectable_nodes_indexes.append(0)
				break

	helping_timer = Timer.new()
	StoredData.world_node.add_child(helping_timer)
	helping_timer.start(5)
	helping_timer.connect("timeout", self, "on_timeout_help_user")


func _trigger_on_correct_once() -> void:
	if helping_timer and is_instance_valid(helping_timer):
		helping_timer.queue_free()
	
func on_timeout_help_user():
	if node_0 and is_instance_valid(helping_timer):
		node_0.show_animation_of_clicking_mouse()
	
func _trigger_on_next_line_side_effect() -> void:
	var t = StoredData.nodes[0]
	StoredData.add_variable("t", t.get_adt())
	t.unhighlight_node()
