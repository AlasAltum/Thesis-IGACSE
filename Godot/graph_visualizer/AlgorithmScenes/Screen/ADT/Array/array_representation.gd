class_name ArrayRepresentation
extends ADTRepresentation



onready var nodes_vbox: VBoxContainer = $NodesHBox
var label_indexes: Dictionary = {}  # Dictionary<int, Label>

func _ready() -> void:
	self.position = Vector2(80.0, 20.0)

# Not needed.
func add_node(node) -> void:
	printerr("Until now this is not necessary ")
	return

# TODO: Implement this
func add_data(edge) -> void:
	return

# This is not necessary.
func remove_node(node) -> void:
	printerr("this should not be called")
	return

func clear():
	label_indexes.clear()
	for child in nodes_vbox.get_children():
		child.queue_free()

func get_class() -> String:
	return "ArrayRepresentation"
