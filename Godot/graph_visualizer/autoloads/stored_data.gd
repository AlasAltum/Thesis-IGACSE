# class_name StoredData
extends Node2D
# This object creates the graph and also communicates with the rest
# of the nodes in the world. It works as a bridge between
# the Autoload StoredData and the world nodes.

enum mov_status {SELECT = 0, DRAG = 1}

var allow_select_edges = false
var status : int = mov_status.SELECT;
var nodes : Array = []  # PoolAGraphNodeArray
var edges : Array = []

var debug_block: ScrollContainer  # : DebugBlock
var json_matrix = []  # contains pairs [node_index <int>, weight <float>]:
var json = {
	"n": 3,
	"matrix": [],
}
var dragging_adt : bool = false
var dragged_adt : FollowingMouseTexture
var selected_edge
var min_weight: float
var adt_hovering : bool = false
var assign_name_popup : WindowDialog
var world_node: Node2D  # : GraphManager
const status_map = {
	"DRAG": mov_status.DRAG,
	"SELECT": mov_status.SELECT
}
var selectable_nodes = []
## Code continue conditions
var u_is_explored_right_answer : bool = false
var adt_is_empty_right_answer : bool = false
## ADT selection
var adt_shower
var adt_mediator # ADTMediator class
var selected_variable_index : int = 0  # Used to emphasize the current variable
var adt_to_be_created: ADT


func get_status():
	return status

func set_status(incoming_state: String):
	self.status = status_map[incoming_state]

func set_adt_mediator(_adt_mediator):
	adt_mediator = _adt_mediator

# var nodes : Array = []  # PoolAGraphNodeArray
func get_selected_nodes() -> Array:
	var selected_nodes: Array = []
	for _node in self.nodes:
		if _node.selected:
			selected_nodes.append(_node)

	return selected_nodes

func set_hint_text(new_text: String) -> void:
	NotificationManager.set_hint_text(new_text)

func make_following_texture_opaque():
	if self.dragging_adt:
		dragged_adt.modulate = Color(1.0, 1.0, 1.0, 1.0)
		adt_hovering = true

func make_following_texture_transparent():
	if self.dragging_adt:
		dragged_adt.modulate = Color(1.0, 1.0, 1.0, 0.3)
		adt_hovering = false


# TODO: ERASE THIS
# ask for variable name to add it to the heap
#func _on_adt_drop_on_heap():
#	assign_name_popup = get_tree().get_root().get_node("Main/PopUpForObjectCreation")
#	assign_name_popup.show()
#	# We still need it for variable creation, so we just make it invisible
#	self.dragged_adt.visible = false
#	self.dragging_adt = false


# Create a new variable, considering it in the
# ADT Shower and in the Debug Block
func add_variable(var_name, data):
	if data.get_class() == "KinematicBody2D":
		data = data.get_adt()
	elif data.get_class() == "GraphEdge":
		var parent_edge = data
		data = data.get_adt().new(parent_edge)
	adt_mediator.add_or_update_variable(var_name, data)


func has_variable(variable_name: String) -> bool:
	return adt_mediator.has_variable(variable_name)

func get_variable(variable_name: String):
	return adt_mediator.get_variable(variable_name)

func erase_variable(var_name: String) -> void:
	adt_mediator.erase_variable_by_name(var_name)

func get_data_type_of_variable(var_name: String):
	# Case there is no data type for that variable
	if not self.has_variable(var_name):
		return ""
	return adt_mediator.get_variable(var_name).get_type()

func get_selected_edge():
	return selected_edge

# When game gets reset, reset data
func reset_data():
	self.selected_variable_index = 0
	self.selectable_nodes = []
	self.status = mov_status.SELECT;
	self.nodes = []  # PoolAGraphNodeArray
	self.json_matrix = []
	self.json = {
		"n": 3,
		"matrix": [],
	}
	self.dragging_adt = false
	self.dragged_adt = null
	self.adt_hovering = false
	self.assign_name_popup = null
	self.world_node = null

