class_name QueueRepresentation
extends ADTRepresentation
# This class is intended to be shown in the ADTShower class

onready var node_label_prefab = preload("res://AlgorithmScenes/Screen/ADT/NodeInADT.tscn")
onready var nodes_vbox: VBoxContainer = $NodesVBox
var label_indexes: Dictionary = {}  # Dictionary<int, Label>

# Add new node to the QueueADT representation
func _add_node(node: AGraphNode) -> void:
	var new_label: Label = node_label_prefab.instance()
	new_label.text = str(node.index)
	# Change name in tree, so it can be erased later by using its index
	new_label.name = "NodeInQueue" + str(node.index)
	label_indexes[node.index] = new_label
	nodes_vbox.add_child(new_label)
	nodes_vbox.move_child(new_label, 0)

# Remove Node from QueueADT representation
func _remove_node(node: AGraphNode) -> void:
	var child_to_remove: Label = label_indexes[node.index]
	child_to_remove.queue_free()


