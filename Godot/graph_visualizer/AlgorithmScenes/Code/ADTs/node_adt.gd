class_name NodeADT
extends ADT

var parent_node  # AGraphNode

func _init(_parent_node):
	parent_node = _parent_node

func _ready():
	pass # Replace with function body.

static func get_type() -> String:
	return "Node"

func as_string() -> String:
	return "(" + str(parent_node.index) + ")"

func get_object(): # -> ADT:
	return self

func get_representation(): # -> ADTRepresentation:
	return parent_node.get_representation()

func get_node():
	return parent_node
