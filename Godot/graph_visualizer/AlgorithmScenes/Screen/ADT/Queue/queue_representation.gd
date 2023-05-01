class_name QueueRepresentation
extends ADTRepresentation
# This class is intended to be shown in the ADTShower class

const node_label_prefab = preload("res://AlgorithmScenes/Screen/ADT/NodeInADT.tscn")
onready var nodes_vbox: VBoxContainer = $NodesVBox
var label_indexes: Dictionary = {}  # Dictionary<int, Label>

const REMOVE_NODE_ERROR_MSG_REPEATED_LABEL_WAS_REMOVED: String = "Error trying to get index of value already removed. You added a node twice"


func _ready() -> void:
	self.position = Vector2(80.0, 20.0)

# Add new node to the QueueADT representation
func add_node(node) -> void:
	var new_label: Label = node_label_prefab.instance()
	new_label.text = str(node.index)
	# Change name in tree, so it can be erased later by using its index
	new_label.name = "NodeInQueue" + str(node.index)
	label_indexes[node.index] = new_label
	nodes_vbox.add_child(new_label)
	nodes_vbox.move_child(new_label, 0)

# Remove Node from QueueADT representation
func remove_node(node) -> void:
	if not label_indexes.has(node.index):
		printerr(REMOVE_NODE_ERROR_MSG_REPEATED_LABEL_WAS_REMOVED)
		return;
	var child_to_remove: Label = label_indexes[node.index]
	if child_to_remove:
		label_indexes.erase(node.index)
		child_to_remove.queue_free()
	else:
		printerr("Problem removing child")

func clear():
	label_indexes.clear()
	for child in nodes_vbox.get_children():
		child.queue_free()


func get_class() -> String:
	return "QueueRepresentation"
