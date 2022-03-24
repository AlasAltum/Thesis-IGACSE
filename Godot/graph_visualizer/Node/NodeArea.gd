extends Area2D

var receiver_node: Node2D
var selected : bool = false


func _ready():
	pass


func _on_Area2D_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		if (event.button_index == BUTTON_LEFT):
			receiver_node._on_presed()
