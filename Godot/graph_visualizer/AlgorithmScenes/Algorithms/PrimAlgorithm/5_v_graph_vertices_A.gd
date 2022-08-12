extends EffectCheck
#    Set V = {graph.vertices} - A

func check_actions_correct() -> bool:
	return true  # This is not required

func execute_side_effect() -> void:
	var v = SetADT.new()
	var all_nodes = StoredData.nodes
	for node in all_nodes:
		v.add_data(node)
	var nodes_in_a: Array = StoredData.get_variable("A").data
	for node_in_a in nodes_in_a:
		v.substract_data(node_in_a)
	StoredData.add_variable("V", v)


func get_next_line() -> int:
	self.execute_side_effect()
	return .get_next_line()  # super.get_next_line()
