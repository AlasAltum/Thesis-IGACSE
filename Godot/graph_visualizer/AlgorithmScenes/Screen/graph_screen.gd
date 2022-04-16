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

	for i in range(num_nodes):
		StoredData.json["matrix"].append([])
		for j in range(num_nodes):
			if randf() < density and i != j:
				StoredData.json["matrix"][i].append(
					stepify( rand_range(1.0, max_weight), 0.01)
				) 
			else:
				StoredData.json["matrix"][i].append(0.0)


func _ready():
	self.screen_size = get_viewport().get_visible_rect().size
	left = 100
	right = + int(self.screen_size.x)
	up = + int(self.screen_size.y)
	down = 100
	randomize()
	create_nodes_with_weights(10, 5, 0.2)

	instance_nodes()
	instance_edges()

func _on_node_instanced(node: AGraphNode):
	# Set index and edges for node
	node.set_index(StoredData.nodes.size())
	node.set_edges(StoredData.json['matrix'][node.index])
	node.init_radial_position(StoredData.json["n"])
	
	node.connect("node_add_to_object", self, "_on_node_add_to_object")
	
	StoredData.nodes.append(node)


func instance_nodes():
	for _i in range(StoredData.json['matrix'].size()):
		var curr_node : AGraphNode = circle.instance()
		self.add_child(curr_node)
		_on_node_instanced(curr_node)


func instance_edges():
	for i in range(StoredData.json['matrix'].size()):
		for j in range(StoredData.json['matrix'][i].size()):
			if StoredData.json['matrix'][i][j] != 0:
				instance_edge_between_nodes( i, j, str(StoredData.json['matrix'][i][j]) )


func instance_edge_between_nodes(node_idx1: int, node_idx2: int, label: String):
	# Adds an edge with label between the nodes with the given indexes
	var curr_edge = edge.instance()
	curr_edge.set_name("Edge_%s_to_%s" % [str(node_idx1), str(node_idx2)])
	
	self.add_child(curr_edge)
	curr_edge.set_label_and_positions_with_nodes(
		StoredData.nodes[node_idx1],  # pos node_idx1,
		StoredData.nodes[node_idx2],  # pos node_idx2,
		label  # label
	)


func _on_AllowGraphMovementButton_pressed():
	StoredData.set_status("DRAG")


func _on_SelectNodeButton_pressed():
	StoredData.set_status("SELECT")


func _on_node_add_to_object(node: AGraphNode):
	var add_node_popup : AddNodePopup = $AddNodePopup
	add_node_popup.popup()
	add_node_popup.incoming_node = node
