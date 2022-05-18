extends Node2D
class_name GraphManager

## Graph related variables
var screen_size : Vector2
var left: int
var right: int
var up: int
var down: int
var circle = preload("res://Node/Circle.tscn")
var edge = preload("res://Node/Edge.tscn")
var nodes_positions : PoolVector2Array = []

export (float) var graph_density = 0.1
export (int) var graph_size = 5
export (float) var edge_max_weight = 5.0
export (bool) var weighted_graph = false

## Code execution popups ##
onready var finished_popup : WindowDialog = $BFSFinishedPopup
onready var u_is_explored_popup : WindowDialog = $UNodeIsExploredPopup
onready var q_is_empty_popup : WindowDialog = $QIsNotEmptyPopup

## Hint Label ##
onready var hint_label: RichTextLabel = $CanvasLayer/TextHintContainer/HintLabel

## Continue conditions ##
var u_is_explored: bool = false
var q_is_empty: bool = false

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


func _ready():
	self.screen_size = get_viewport().get_visible_rect().size
	left = 100
	right = + int(self.screen_size.x)
	up = + int(self.screen_size.y)
	down = 100
	randomize()
	create_nodes_with_weights(graph_size, edge_max_weight)
	instance_nodes()
	instance_edges()
	create_additional_weights_to_make_graph_connected(graph_size, edge_max_weight)
	instance_edges()
	StoredData.world_node = self

# node: AGraphNode
func _on_node_instanced(node):
	# Set index and edges for node
	node.set_index(StoredData.nodes.size())
	node.set_edges(StoredData.json_matrix[node.index])
	node.init_radial_position(StoredData.json["n"])
	# Connect signals
	node.connect("node_add_to_object", self, "_on_node_add_to_object")
	StoredData.nodes.append(node)


func instance_nodes():
	for _i in range(StoredData.json_matrix.size()):
		var curr_node = circle.instance()  # curr_node: AGraphNode
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
	if weighted_graph == false:
		label_with_weight = ""
	curr_edge.set_label_and_positions_with_nodes(
		StoredData.nodes[node_idx1],  # pos node_idx1,
		StoredData.nodes[node_idx2],  # pos node_idx2,
		label_with_weight  # label
	)

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
func create_additional_weights_to_make_graph_connected(num_nodes, max_weight):
	for _i in range(StoredData.nodes.size()):
		var node = StoredData.nodes[_i]  # AGraphNode
		var i = node.index  # _i may not be equal to i
		if not _graph_is_connected():
			# We need to connect this node's tree to other tree
			var connected_nodes = _get_connected_nodes_for_node(node)
			var j = _get_index_of_node_absent_in_array(connected_nodes)
			var weight = stepify( rand_range(1.0, max_weight), 0.01 )
			StoredData.json_matrix[i].append( [j, weight] )
			StoredData.json_matrix[j].append( [i, weight] )


func _on_AllowGraphMovementButton_pressed():
	StoredData.set_status("DRAG")


func _on_SelectNodeButton_pressed():
	StoredData.set_status("SELECT")


# node: AGraphNode
# Commented to avoid Ciclyc dependencies
func _on_node_add_to_object(node):
	var add_node_popup : AddNodePopup = $AddNodePopup
	add_node_popup.popup()
	add_node_popup.incoming_node = node


# StoredData Autoload will trigger
# func on_code_finished_popup(_msg: String):
#	self.world_node.on_code_finished_popup(_msg)
func on_code_finished_popup(_msg: String) -> void:
	finished_popup.show()
#	return
## Node related functions ##

## Hint related methods ##
func set_hint_text(new_text: String) -> void:
	self.hint_label.bbcode_text = new_text
## Hint related methods ##

## BFS Finished Popup signals ##

func _on_ResetButton_pressed() -> void:
	StoredData.reset_data()
	get_tree().reload_current_scene()


func _on_MenuButton_pressed() -> void:
	pass # TODO: Add Menu for different algorithms

## BFS Finished Popup signals ##

## U.is_explored() popup signals ##
# Show popup 
func ask_user_if_graph_node_is_explored(u, condition_value: bool):
	u_is_explored_popup.show()
	u_is_explored_popup.get_node("Explanation").text = "Is the U node (" + str(u.index) + ") explored?"
	 # This stablishes whether yes or no should be pressed
	self.u_is_explored = condition_value

func notify_u_is_explored_correct_answer():
	StoredData.u_is_explored_right_answer = true
	u_is_explored_popup.hide()
	# TODO: Add sound effect
	# TODO: Add visual effect

func notify_u_is_explored_wrong_answer():
	# Visual effect
	$UNodeIsExploredPopup/ErrorNotification/AnimationPlayer.stop()
	$UNodeIsExploredPopup/ErrorNotification/AnimationPlayer.play("message_modulation")
	# TODO: Add sound effect

func _on_YesButton_pressed() -> void:
	if self.u_is_explored:  # Expected answer
		# Close the popup
		notify_u_is_explored_correct_answer()
	else: # Wrong answer
		notify_u_is_explored_wrong_answer()


func _on_NoButton_pressed() -> void:
	if self.u_is_explored:  # Wrong answer
		notify_u_is_explored_wrong_answer()
	else:  # Expected answer
		# Close the popup
		notify_u_is_explored_correct_answer()

## U.is_explored() popup signals ##

## q.is_not_empty() popup signals ##
func ask_user_if_queue_is_empty(is_q_empty: bool):
	q_is_empty_popup.show()
	 # This stablishes whether yes or no should be pressed
	self.q_is_empty = is_q_empty


func _on_q_is_empty_YesButton_pressed() -> void:
	if self.q_is_empty:  # Wrong
		self.notify_q_is_empty_wrong_answer()
	else:  # Right!
		self.notify_q_is_empty_correct_answer()

func _on_q_is_empty_NoButton_pressed() -> void:
	# if q is empty, expected answer is yes
	if self.q_is_empty:
		self.notify_q_is_empty_correct_answer()
	else:  # Wrong
		self.notify_q_is_empty_wrong_answer()

func notify_q_is_empty_correct_answer():
	StoredData.q_is_empty_right_answer = true
	q_is_empty_popup.hide()

func notify_q_is_empty_wrong_answer():
	# Visual effect
	$QIsNotEmptyPopup/ErrorNotification/AnimationPlayer.stop()
	$QIsNotEmptyPopup/ErrorNotification/AnimationPlayer.play("message_modulation")
	# TODO: Add sound effect


## utils for connected graphs ##
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
func _graph_is_connected() -> bool:
	for node in StoredData.nodes:
		if _get_connected_nodes_for_node(node).size() != self.graph_size:
			return false
	return true
