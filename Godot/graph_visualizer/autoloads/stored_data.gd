extends Node2D
# class_name StoredData

enum mov_status {SELECT = 0, DRAG = 1}

var status : int = mov_status.DRAG;
var nodes : Array = []  # PoolAGraphNodeArray
var heap : ScrollContainer  # It is a DebugBlock, but we cannot specify it
var json = {
	"n": 3,
	"matrix": [],
}
var heap_dictionary : Dictionary = {}
var dragging_adt : bool = false
var dragged_adt : FollowingMouseTexture
var adt_hovering : bool = false
var popup : WindowDialog
var variable_to_add
const status_map = {
	"DRAG": mov_status.DRAG,
	"SELECT": mov_status.SELECT
}

func get_status():
	return status

func set_status(incoming_state: String):
	self.status = status_map[incoming_state]


func has_variable(variable_name: String):
	return variable_name in heap_dictionary or heap.has_variable(variable_name)


func add_variable(var_name, data):
	if heap:
		if has_variable(var_name):
			heap.modify_variable(var_name, data)
		else:
			heap.add_variable(var_name, data)
		heap_dictionary[var_name] = data  # just replace value


func get_selected_nodes() -> Array:
	var selected_nodes : Array = []
	for _node in self.nodes:
		if _node.selected:
			selected_nodes.append(_node)

	return selected_nodes


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
	popup = get_tree().get_root().get_node("/root/Main/Popup")
	popup.visible = true

# if the variable was correctly created from the ADT Grid
func _on_correct_variable_creation(variable_name: String):
	self.dragging_adt = false
	self.add_variable(
		variable_name,
		self.dragged_adt.as_variable()
	)
	self.dragged_adt.queue_free()
	self.dragged_adt = null


func get_data_type_of_variable(var_name: String):
	# Case there is no data type for that
	if not self.has_variable(var_name):
		return ""
	print(str(heap_dictionary[var_name]))
	return str(heap_dictionary[var_name])
