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


## Continue conditions ##
var u_is_explored: bool = false
var q_is_empty: bool = false


func create_nodes_with_weights(num_nodes: int, max_weight: int):
	StoredData.json["n"] = num_nodes

	for _i in range(num_nodes):
		StoredData.json_matrix.append([])

	for i in range(num_nodes):
		for j in range(i + 1, num_nodes):
			if randf() < self.graph_density and i != j:
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
	create_nodes_with_weights(graph_size, edge_max_weight)

	instance_nodes()
	instance_edges()
	
	StoredData.world_node = self

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
	if weighted_graph == false:
		label_with_weight = ""
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


# StoredData Autoload will trigger
# func on_code_finished_popup(_msg: String):
#	self.world_node.on_code_finished_popup(_msg)
func on_code_finished_popup(_msg: String) -> void:
	finished_popup.show()
#	return

## BFS Finished Popup signals ##

func _on_ResetButton_pressed() -> void:
	StoredData.reset_data()
	get_tree().reload_current_scene()


func _on_MenuButton_pressed() -> void:
	pass # TODO: Add Menu for different algorithms

## BFS Finished Popup signals ##

## U.is_explored() popup signals ##
# Show popup 
func ask_user_if_graph_node_is_explored(u: AGraphNode, condition_value: bool):
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
