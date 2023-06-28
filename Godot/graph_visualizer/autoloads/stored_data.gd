#class_name StoredData
extends Node2D
# This object creates the graph and also communicates with the rest
# of the nodes in the world. It works as a bridge between
# the Autoload StoredData and the world nodes.

# The code should be used in conjunction with other classes and scripts to create a graph and 
# communicate with other nodes in the world. It provides functions to add and remove variables,
# nodes, and edges to the ADT, update views, get data type of a variable, get selected edge,
# get node by index, reset data, and more. The code is written in GDScript and should be used 
# in the Godot game engine.

var story_mode_scenes = {
	"Story1": "res://GameFlow/Tutorials/StoryModeChapterOne.tscn",
	"Tutorial1": "res://GameFlow/Tutorials/FirstTutorialSelectPlanet.tscn",
	"Tutorial2": "res://GameFlow/Tutorials/SecondTutorial.tscn",
	"BFS": "res://AlgorithmScenes/Algorithms/BFSAlgorithmTutorial/BFS_tutorial.tscn",
}

var finished_levels = {
	"BFS": false,
	"DFS": false,
	"Prim": false,
	"Kruskal": false,
}

var remaining_levels_to_finish = {
	"BFS": "res://AlgorithmScenes/Algorithms/BFSAlgorithmTutorial/BFS_tutorial.tscn",
	"DFS": "res://AlgorithmScenes/Algorithms/DFSAlgorithm/DFS_styled.tscn",
	"Prim": "res://AlgorithmScenes/Algorithms/KruskalAlgorithm/Kruskal_styled.tscn",
	"Kruskal": "res://AlgorithmScenes/Algorithms/PrimAlgorithm/Prim_styled.tscn",
}

var API_URL = "http://localhost:7071/api/igasce"
var types_with_adt: Array = ["KinematicBody2D", "GraphEdge", "AGraphNode"]
var has_initialized: bool = false  # Used in C# in the main menu
var allow_select_edges = false
var nodes : Array = []  # PoolAGraphNodeArray
var edges : Array = []
var debug_block: ScrollContainer  # : DebugBlock
var number_of_nodes: int = 3
var number_of_edges: int = 0
var matrix: Array = []
var dragging_adt : bool = false
var selected_edge
var adt_hovering : bool = false
var popup_captures_input : bool = false
var assign_name_popup : WindowDialog
var world_node: Node  # : GraphManager
var selectable_nodes = []
var selected_edges = []
var iterated_nodes = []
var allow_nodes_dragging = false

## Code continue conditions
# These are popups that ask the user about a condition in the code execution
# If the answer is right, the user may pass to the next line
var v_is_explored_right_answer : bool = false  # BFS & DFS
var adt_is_empty_right_answer : bool = false  # BFS & DFS
var length_c_is_one_correct_answer: bool = false  # Kruskal1
var find_w_unequal_find_v_correct_answer: bool = false  # Kruskal2

var nodes_that_should_be_added_to_adt = []
var highlighted_edge = null

## ADT selection
var adt_shower # ADTShower
var adt_mediator # ADTMediator class
var selected_variable_index : int = 0  # Used to emphasize the current variable
var adt_to_be_created: ADT

var allow_sending_request: bool = true

const target_cursor = preload("res://AlgorithmScenes/Screen/Assets/TargetWorldCursor.png")


func _ready():
	Input.set_custom_mouse_cursor(target_cursor, Input.CURSOR_CROSS)

func set_adt_mediator(_adt_mediator):
	adt_mediator = _adt_mediator

# var nodes : Array = []  # PoolAGraphNodeArray
func get_selected_nodes() -> Array:
	var selected_nodes: Array = []
	for _node in self.nodes:
		if _node.selected:
			selected_nodes.append(_node)

	return selected_nodes


func emphasize_current_selected_variable():
	if adt_mediator:
		adt_mediator.emphasize_current_selected_variable()


func emphasize_error_on_current_selected_variable():
	if adt_mediator:
		adt_mediator.emphasize_error_on_current_selected_variable()
		AudioPlayer.play_error_audio()

# We don't want to add the whole node, but its representation
# as an ADT, so we feed with this to the ADTMediator
func _transform_data_from_nodes_and_edges(data):
	if types_with_adt.has(data.get_class()):
		data = data.get_adt()
	# The same with edges
	elif data.get_class() == "GraphEdge":
		var parent_edge = data
		data = data.get_adt().new(parent_edge)
	return data
	
# Create a new variable, considering it in the
# ADT Shower and in the Debug Block
func add_variable(var_name, data):
	# If the data is a raw node or edge, we want to get its ADT
	data = _transform_data_from_nodes_and_edges(data)

	# If we are setting the name of a node, set its name
	if data.get_class() == "NodeADT":
		data.get_node().highlight_variable(var_name)

	adt_mediator.add_or_update_variable(var_name, data)
	highlight_variable(var_name)

func highlight_variable(var_name: String) -> void:
	var_name = var_name.to_lower()
	adt_mediator.highlight_variable(var_name)

func has_variable(variable_name: String) -> bool:
	return adt_mediator.has_variable(variable_name)

func get_variable(variable_name: String):
	return adt_mediator.get_variable(variable_name)

func erase_variable(var_name: String) -> void:
	if StoredData.has_variable(var_name):
		adt_mediator.erase_variable_by_name(var_name)
	else:
		printerr("The variable " + var_name + " does not exist")


func add_node_to_adt(object_name: String, incoming_node: Object) -> void:
	adt_mediator.add_node_to_adt(object_name, incoming_node)

func update_views() -> void:
	adt_mediator.update()

func get_data_type_of_variable(var_name: String):
	# Case there is no data type for that variable
	if not self.has_variable(var_name):
		return ""
	return adt_mediator.get_variable(var_name).get_type()

func get_selected_edge():
	return selected_edge


func node_may_be_added_to_adt(node) -> bool:
	return node in self.nodes_that_should_be_added_to_adt


func selected_variable_allows_object_adition(node) -> bool:
	if adt_mediator && adt_mediator.has_method("selected_variable_allows_object_adition"):
		var node_may_be_added_to_adt = node_may_be_added_to_adt(node)
		var selected_variable_allows_object_adition = adt_mediator.selected_variable_allows_object_adition()
		return node_may_be_added_to_adt && selected_variable_allows_object_adition
	return false

func get_selected_variable_name() -> String:
	return adt_mediator.get_selected_variable_name()


## These functions are to avoid user from adding multiple times the same
## node or the wrong node to an ADT, avoiding to make the user feel frustrated
func add_node_to_nodes_that_should_be_added_to_adt(node):
	self.nodes_that_should_be_added_to_adt.append(node)


func remove_node_from_nodes_that_should_be_added_to_adt(node):
	self.nodes_that_should_be_added_to_adt.erase(node)


func get_edge_between_nodes(node1, node2):
	for edge in self.edges:
		if (
			(edge.joint_end1 == node1 and edge.joint_end2 == node2) or 
			(edge.joint_end1 == node2 and edge.joint_end2 == node1)
		):
			return edge


func set_highlighted_edge(_edge):
	if self.highlighted_edge:
		self.highlighted_edge.set_is_highlighted(false)
	if _edge:
		_edge.set_is_highlighted(true)
		self.highlighted_edge = _edge

func get_node_by_index(input_index):
	for node in self.nodes:
		if node.index == input_index:
			return node

# When game gets reset, reset data excepting finished_levels 
func reset_data():
	self.allow_select_edges = false;
	self.nodes = []  # PoolAGraphNodeArray
	self.edges = []
	self.debug_block = null
	self.number_of_nodes = 3
	self.number_of_edges = 0
	self.matrix = []
	self.dragging_adt = false
	self.selected_edge = null
	self.adt_hovering = false
	self.popup_captures_input = false
	self.assign_name_popup = null
	self.world_node = null
	self.selectable_nodes = []
	self.selected_edges = []
	self.iterated_nodes = []

	## Code continue conditions
	self.v_is_explored_right_answer = false
	self.adt_is_empty_right_answer = false
	self.length_c_is_one_correct_answer = false
	self.find_w_unequal_find_v_correct_answer = false

	self.nodes_that_should_be_added_to_adt = []
	self.highlighted_edge = null

	## ADT selection
	self.adt_shower = null
	self.adt_mediator = null
	self.selected_variable_index = 0
	self.adt_to_be_created = null

