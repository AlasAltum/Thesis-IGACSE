extends EffectCheck
# C = [{v} for v in graph.vertices];

# Make a different color representing a different set for each node
# at the beggining. Then, they will start to join, making different Union-Find
# structures.  


func effect_check_on_focused() -> void:
	# for each node, assign a different color to each one
	pass
#	var num_nodes = StoredData.nodes.size()
#	var colors = ColorMap.generate_n_colors(num_nodes)
#
#	assert(colors.size() == num_nodes)
#	for index in range(num_nodes):
#		var current_node: AGraphNode = StoredData.nodes[index]
#		# To have different colors for each node, it is important
#		# That each shader is a separated instance. This can be
#		# achieved by checking the "Local to Scene" box in the Shader's editor
#		current_node.set_color(colors[index])

func _trigger_on_next_line_side_effect() -> void:
	var c_array: ArrayADT = ArrayADT.new()
	for node in StoredData.nodes:
		var set_with_v: SetADT = SetADT.new()
		set_with_v.add_data(node.get_adt())  # We always work with adt in backend
		c_array.add_data(set_with_v)
	StoredData.add_variable("c", c_array)
