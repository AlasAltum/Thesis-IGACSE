class_name StackRepresentation
extends ADTRepresentation
# This class is intended to be shown in the ADTShower class


onready var node_label_prefab = preload("res://AlgorithmScenes/Screen/ADT/NodeInADT.tscn")
onready var nodes_vbox: VBoxContainer = $NodesVBox


func _ready() -> void:
	pass # Replace with function body.


# Add new node to the StackADT representation
func add_node(node: AGraphNode) -> void:
	var new_label: Label = node_label_prefab.instance().get_node("Node")
	new_label.text = str(node.index)
	# Change name in tree, so it can be erased later by using its index
	new_label.name = "NodeInStack" + str(node.index)
	nodes_vbox.add_child(new_label)
	nodes_vbox.move_child(new_label, 0)

# Remove Node from the StackADT representation
func remove_node(node: AGraphNode) -> void:
	var child_to_remove: Label = nodes_vbox.find_node("NodeInStack" + str(node.index))
	child_to_remove.queue_free()

func get_representation() -> StackRepresentation:
	return self.representation
