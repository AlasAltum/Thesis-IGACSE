extends EffectCheck
# v = q.top()

func check_actions_correct() -> bool:
	return true  # This is not required

func execute_side_effect() -> void:
	if StoredData.has_variable("q"):
		var queue : QueueADT = StoredData.get_variable("q")
		var top_node_in_queue : AGraphNode = queue.top()
		StoredData.add_variable("v", top_node_in_queue)

func get_next_line() -> int:
	self.execute_side_effect()
	return .get_next_line()  # super.get_next_line()
