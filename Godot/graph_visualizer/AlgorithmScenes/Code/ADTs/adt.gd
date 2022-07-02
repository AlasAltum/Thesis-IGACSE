# This class is for Data Structures and
# Representing them in the Heap. They also may have
# behaviors for code checking when evaluating
# whether a instruction pointer may pass to the next line
class_name ADT
extends Resource

var representation: ADTRepresentation
var representation_path: String

func _ready():
	pass # Replace with function body.

static func get_type() -> String:
	return "Abstract Object Name"

func as_string() -> String:
	return "Abstract Object"

func get_object() -> ADT:
	return self

func get_representation() -> ADTRepresentation:
	return self.representation
