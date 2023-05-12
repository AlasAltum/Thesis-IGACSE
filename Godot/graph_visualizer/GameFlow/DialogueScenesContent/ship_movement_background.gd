tool
extends Control

onready var ship_movement = $Path2D/PathFollow2D

export (float) var ship_movement_speed = 0.01 

#func _ready():

func _process(delta):
	ship_movement.unit_offset += delta * ship_movement_speed
	# Repeat
	if ship_movement.unit_offset >= 1.0:
		ship_movement.unit_offset = 0.0
