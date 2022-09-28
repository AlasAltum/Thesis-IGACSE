class_name ADTRepresentation
extends Node2D

# To be overriden by:
# NodeRepresentation, StackRepresentation, QueueRepresentation

func _ready() -> void:
	pass # Replace with function body.

# Override this method
func add_node(_node) -> void:
	pass

# Override this method
func remove_node(_node) -> void:
	pass

func set_properties() -> void:
	pass

func get_initial_position() -> Vector2:
	return Vector2(50.0, 10.0)
