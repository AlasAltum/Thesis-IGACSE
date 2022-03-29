extends Node2D
class_name GraphManager

var screen_size : Vector2
var left
var right
var up
var down
var circle = preload("res://Node/Circle.tscn")
var edge = preload("res://Node/Edge.tscn")

var nodes_positions : PoolVector2Array = []
var nodes : Array = []  # PoolAGraphNodeArray
var json = {
	"n": 3,
	"matrix": [],
}


func create_nodes_with_weights(num_nodes: int, max_weight: int, density: float):
	json["n"] = num_nodes

	for i in range(num_nodes):
		json["matrix"].append([])
		for j in range(num_nodes):
			if randf() < density and i != j:
				json["matrix"][i].append(
					stepify( rand_range(1.0, max_weight), 0.01)
				) 
			else:
				json["matrix"][i].append(0.0)


func _ready():
	self.screen_size = get_viewport().get_visible_rect().size
	left = 100
	right = + self.screen_size.x
	up = + self.screen_size.y
	down = 100
	randomize()
	create_nodes_with_weights(5, 5, 0.2)

	instance_nodes()
	instance_edges()


func _on_node_instanced(node: AGraphNode):
	# Set index and edges for node
	node.set_index(self.nodes_positions.size())
	node.set_edges(self.json['matrix'][node.index])
	self.nodes_positions.append(
		node.init_radial_position(json["n"])
	)
	self.nodes.append(node)

func instance_nodes():
	for _i in range(json['matrix'].size()):
		var curr_node : AGraphNode = circle.instance()
		self.add_child(curr_node)
		_on_node_instanced(curr_node)


func instance_edges():
	for i in range(json['matrix'].size()):
		for j in range(json['matrix'][i].size()):
			if json['matrix'][i][j] != 0:
				instance_edge_between_nodes( i, j, str(json['matrix'][i][j]) )


func instance_edge_between_nodes(node_idx1: int, node_idx2: int, label: String):
	# Adds an edge with label between the nodes with the given indexes
	var curr_edge = edge.instance()
	curr_edge.set_name("Edge_%s_to_%s" % [str(node_idx1), str(node_idx2)])
	
	self.add_child(curr_edge)
	curr_edge.set_label_and_positions_with_nodes(
		nodes[node_idx1],  # pos node_idx1,
		nodes[node_idx2],  # pos node_idx2,
		label  # label
	)


