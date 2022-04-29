extends Node2D
class_name GraphManager

var screen_size : Vector2
var left: int
var right: int
var up: int
var down: int
var circle = preload("res://Node/Circle.tscn")
var edge = preload("res://Node/Edge.tscn")

var nodes_positions : PoolVector2Array = []



func create_nodes_with_weights(num_nodes: int, max_weight: int, density: float):
	StoredData.json["n"] = num_nodes

	for _i in range(num_nodes):
		StoredData.json_matrix.append([])

	for i in range(num_nodes):
		for j in range(num_nodes):
			if randf() < density and i != j:
				# TODO: add condition:
				# and StoredData.json_matrix[j] does not contain a pair that has [i]
				# Maybe use a dictionary to make it easier 
				# Add a pair (node number, weight)
				var weight = stepify( rand_range(1.0, max_weight), 0.01)
				StoredData.json_matrix[i].append( [j, weight] )
				StoredData.json_matrix[j].append( [i, weight] )


func _ready():
	self.screen_size = get_viewport().get_visible_rect().size
	left = 100
	right = + int(self.screen_size.x)
	up = + int(self.screen_size.y)
	down = 100
	randomize()
	create_nodes_with_weights(5, 5, 0.2)

	instance_nodes()
	instance_edges()

func _on_node_instanced(node: AGraphNode):
	# Set index and edges for node
	node.set_index(StoredData.nodes.size())
	node.set_edges(StoredData.json_matrix[node.index])
	node.init_radial_position(StoredData.json["n"])
	# Connect signals
	node.connect("node_add_to_object", self, "_on_node_add_to_object")
	
	StoredData.nodes.append(node)


func instance_nodes():
	for _i in range(StoredData.json_matrix.size()):
		var curr_node : AGraphNode = circle.instance()
		self.add_child(curr_node)
		_on_node_instanced(curr_node)


func instance_edges():
	for i in range(StoredData.json_matrix.size()):
		for pair in StoredData.json_matrix[i]:
			# pair = [node_number, weight]
			instance_edge_between_nodes( i, pair[0], str(pair[1]) )

func instance_edge_between_nodes(node_idx1: int, node_idx2: int, label_with_weight: String):
	# Adds an edge with label between the nodes with the given indexes
	var curr_edge = edge.instance()
	curr_edge.set_name("Edge_%s_to_%s" % [str(node_idx1), str(node_idx2)])
	self.add_child(curr_edge)
	curr_edge.set_label_and_positions_with_nodes(
		StoredData.nodes[node_idx1],  # pos node_idx1,
		StoredData.nodes[node_idx2],  # pos node_idx2,
		label_with_weight  # label
	)


func _on_AllowGraphMovementButton_pressed():
	StoredData.set_status("DRAG")


func _on_SelectNodeButton_pressed():
	StoredData.set_status("SELECT")


func _on_node_add_to_object(node: AGraphNode):
	var add_node_popup : AddNodePopup = $AddNodePopup
	add_node_popup.popup()
	add_node_popup.incoming_node = node
