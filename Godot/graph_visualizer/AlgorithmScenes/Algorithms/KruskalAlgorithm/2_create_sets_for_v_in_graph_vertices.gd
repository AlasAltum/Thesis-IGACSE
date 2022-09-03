extends EffectCheck
# C = [[v] for v in graph.vertices];

# Make a different color representing a different set for each node
# at the beggining. Then, they will start to join, making different Union-Find
# structures.  


func effect_check_on_focused() -> void:
	# for each node, assign a different color to each one
	var num_nodes = StoredData.nodes.size()
	var colors = ColorMap.generate_n_colors(num_nodes)
	
	assert(colors.size() == num_nodes)
	for index in range(num_nodes):
		var current_node = StoredData.nodes[index]
		current_node.set_color(colors[index])
