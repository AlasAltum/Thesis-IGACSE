extends Node2D
class_name GraphManager

export (String) var level_name = "BFS" # DFS, Kruskal, Prim...

## Graph related variables
var screen_size : Vector2
var left: int
var right: int
var up: int
var down: int
var circle = preload("res://Node/Node.tscn")
var edge = preload("res://Node/Edge.tscn")

export (float) var graph_density = 0.1
export (int) var graph_size = 5
export (float) var edge_max_weight = 5.0
export (bool) var is_weighted_graph = false
export (bool) var allow_selected_edges = false

## Hint Label ##
onready var hint_label: RichTextLabel = $TextHintContainer/HintLabel
onready var adt_mediator = $ADTMediator


func _ready():
	self.screen_size = get_viewport().get_visible_rect().size
	left = 100
	right = + int(self.screen_size.x)
	up = + int(self.screen_size.y)
	down = 100
	randomize()
	create_nodes_with_weights(graph_size, edge_max_weight)
	instance_nodes()
#	instance_edges()  # Make edges randomly
	create_additional_weights_to_make_graph_connected(edge_max_weight)
	instance_edges()  # To make sure the graph is connected
	StoredData.world_node = self
	for _edge in StoredData.edges:
		_edge.set_collision_box()  # TODO: error when reseting
	StoredData.allow_select_edges = self.allow_selected_edges
	self.add_to_group("Main")
	# TODO: ERASE
#	var dataserver = DataServer.new()
#	dataserver.send_data(
#		{
#			'clicks': [1, 2, 3, 5, 6],
#			'errors': ['bad click on node', 'bad click on conditional'],
#		}
#	)


func _init_graph_matrix(num_nodes: int) -> void:
	StoredData.json["n"] = num_nodes
	for _i in range(num_nodes):
			StoredData.json_matrix.append([])

# Node related functions
func create_nodes_with_weights(num_nodes: int, max_weight: int):
	_init_graph_matrix(num_nodes)
	for i in range(num_nodes):
		for j in range(i + 1, num_nodes):
			if randf() < self.graph_density and i != j:
				var weight = stepify( rand_range(1.0, max_weight), 0.01)
				StoredData.json_matrix[i].append( [j, weight] )
				StoredData.json_matrix[j].append( [i, weight] )


func instance_nodes():
	for _i in range(StoredData.json_matrix.size()):
		var curr_node = circle.instance()  # curr_node: AGraphNode
		self.add_child(curr_node)
		_on_node_instanced(curr_node)


# node: AGraphNode
func _on_node_instanced(node):
	# Set index and edges for node
	node.set_index(StoredData.nodes.size())
	node.set_edges(StoredData.json_matrix[node.index])
	node.init_radial_position(StoredData.json["n"])
	# Connect signals
	node.connect("node_add_to_object_request", NotificationManager, "_on_node_add_to_object")
	StoredData.nodes.append(node)


func instance_edges():
	for i in range(StoredData.json_matrix.size()):
		for pair in StoredData.json_matrix[i]:
			# pair = [node_number, weight]
			if i < pair[0]:
				instance_edge_between_nodes( i, pair[0], str(pair[1]) )

func instance_edge_between_nodes(node_idx1: int, node_idx2: int, label_with_weight: String):
	# Adds an edge with label between the nodes with the given indexes
	var curr_edge = edge.instance()
	curr_edge.set_name("Edge_%s_to_%s" % [str(node_idx1), str(node_idx2)])
	StoredData.edges.append(curr_edge)
	self.add_child(curr_edge)
	curr_edge.set_label_and_positions_with_nodes(
		StoredData.nodes[node_idx1],  # pos node_idx1,
		StoredData.nodes[node_idx2],  # pos node_idx2,
		label_with_weight  # label
	)
	curr_edge.set_weight_visible(is_weighted_graph)  # invisible if BFS or DFS

# Get a node whose index is not in the given array
# So we know that if we have two separated trees, we can join them
# using this
func _get_index_of_node_absent_in_array(connected_node_indexes: Array) -> int:
	# i.e connected_node_indexes = [1, 4, 6]
	# all_nodes = [1, 2, 3, 4, 5, 6]
	# so we could get a number like 2, 3 or 5
	var complement = []
	for node_index in StoredData.nodes:
		if not node_index in connected_node_indexes:
			complement.append(node_index)

	var generator = RandomNumberGenerator.new()
	var complement_index_to_return = generator.randi_range(0, complement.size() - 1)
	return complement[complement_index_to_return].index


# For each node V_i, check if the graph is connected from that node.
# If not, find a node V_j whose index is not in the connected component of V_i
# If we make an edge between (V_i, V_j), then we make another connected component
# If we do that for each node, we surely will end up with a connected graph
func create_additional_weights_to_make_graph_connected(max_weight):
	for _i in range(StoredData.nodes.size()):
		var node = StoredData.nodes[_i]  # AGraphNode
		var i = node.index  # _i may not be equal to i
		if not _is_graph_connected():
			# We need to connect this node's tree to other tree
			var connected_nodes = _get_connected_nodes_for_node(node)
			var j = _get_index_of_node_absent_in_array(connected_nodes)
			var weight = stepify( rand_range(1.0, max_weight), 0.01 )
			StoredData.json_matrix[i].append( [j, weight] )
			StoredData.json_matrix[j].append( [i, weight] )


# utils for connected graphs ##
# Perform a BFS and get connected nodes
# node: AGraphNode
func _get_connected_nodes_for_node(node) -> Array:
	var queue: Queue = Queue.new()
	var visited: Array = []
	queue.push(node)
	visited.append(node)

	while queue.is_not_empty():
		var current_node = queue.pop()  # current_node: AGraphNode
		for neighbor_node in current_node.get_edges():
			# Select node Object, not pair <index, weight>
			neighbor_node = StoredData.nodes[neighbor_node[0]]
			if not neighbor_node in visited:
				queue.push(neighbor_node)
				visited.append(neighbor_node)

	return visited


# If graph of size N is connected:
# after a BFS exploration starting from every node
# should find at least N 
func _is_graph_connected() -> bool:
	for node in StoredData.nodes:
		if _get_connected_nodes_for_node(node).size() != self.graph_size:
			return false
	return true
