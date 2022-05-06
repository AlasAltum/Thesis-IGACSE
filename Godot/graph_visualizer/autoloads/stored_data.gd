# class_name StoredData
extends Node2D
# This object creates the graph and also communicates with the rest
# of the nodes in the world. It works as a bridge between
# the Autoload StoredData and the world nodes.

enum mov_status {SELECT = 0, DRAG = 1}

var status : int = mov_status.SELECT;
var nodes : Array = []  # PoolAGraphNodeArray
var heap : ScrollContainer  # Class DebugBlock
var json_matrix = []
var json = {
	"n": 3,
	"matrix": [],
}
var heap_dictionary : Dictionary = {}
var dragging_adt : bool = false
var dragged_adt : FollowingMouseTexture
var adt_hovering : bool = false
var assign_name_popup : WindowDialog
var variable_to_add
var world_node: Node2D  # : GraphManager
const status_map = {
	"DRAG": mov_status.DRAG,
	"SELECT": mov_status.SELECT
}
var selectable_nodes = []
## Code continue conditions
var u_is_explored_right_answer : bool = false
var q_is_empty_right_answer : bool = false


func get_status():
	return status

func set_status(incoming_state: String):
	self.status = status_map[incoming_state]

func get_selected_nodes() -> Array:
	var selected_nodes: Array = []
	for _node in self.nodes:
		if _node.selected:
			selected_nodes.append(_node)

	return selected_nodes

func set_hint_text(new_text: String) -> void:
	self.world_node.set_hint_text(new_text)

func make_following_texture_opaque():
	if self.dragging_adt:
		dragged_adt.modulate = Color(1.0, 1.0, 1.0, 1.0)
		adt_hovering = true

func make_following_texture_transparent():
	if self.dragging_adt:
		dragged_adt.modulate = Color(1.0, 1.0, 1.0, 0.3)
		adt_hovering = false


# ask for variable name to add it to the heap
func _on_adt_drop_on_heap():
	assign_name_popup = get_tree().get_root().get_node("/root/Main/AssignNameToDataStructurePopup")
	assign_name_popup.visible = true
	self.dragged_adt.visible = false
	self.dragging_adt = false


# if the variable was correctly created from the ADT Grid
func _on_correct_variable_creation(variable_name: String):
	self.add_variable(
		variable_name,
		self.dragged_adt.get_object()
	)
	self.dragged_adt.queue_free()
	self.dragged_adt = null


func has_variable(variable_name: String) -> bool:
	return variable_name in heap_dictionary # or heap.has_variable(variable_name)

func get_variable(variable_name: String):
	return heap_dictionary[variable_name]

	
func add_variable(var_name, data):
	heap_dictionary[var_name] = data
	_on_data_update()

func erase_variable(var_name: String) -> void:
	heap_dictionary.erase(var_name)
	_on_data_update()

func get_data_type_of_variable(var_name: String):
	# Case there is no data type for that
	if not self.has_variable(var_name):
		return ""
	return heap_dictionary[var_name].get_type()


# add a node to object in variables list
func add_node_to_object(variable_name: String, node: AGraphNode):
	if has_variable(variable_name):
		var var_data = heap_dictionary[variable_name]
		var_data.add_data(node)  # This method should be special for every ADT
		heap_dictionary[variable_name] = var_data
		_on_data_update()
#		heap.modify_variable(variable_name, var_data)

func _on_data_update():
	heap.update_data_with_dictionary(self.heap_dictionary)

# TODO: Create a notification
func notify(msg: String) -> void:
	print(msg)


func on_code_finished_popup(_msg: String):
	self.world_node.on_code_finished_popup(_msg)

func ask_user_if_graph_node_is_explored(u: AGraphNode, condition_value: bool):
	self.world_node.ask_user_if_graph_node_is_explored(u, condition_value)

func ask_user_if_queue_is_empty(is_q_empty: bool):
	self.world_node.ask_user_if_queue_is_empty(is_q_empty)

# When game gets reset, reset data
func reset_data():
	self.status = mov_status.SELECT;
	self.nodes = []  # PoolAGraphNodeArray
	self.heap = null # Class DebugBlock
	self.json_matrix = []
	self.json = {
		"n": 3,
		"matrix": [],
	}
	self.heap_dictionary = {}
	self.dragging_adt = false
	self.dragged_adt = null
	self.adt_hovering = false
	self.assign_name_popup = null
	self.variable_to_add = null
	self.world_node = null
