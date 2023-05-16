class_name Part1Background
extends Control

# Name of the node: Part1Background
onready var ship_movement = $Path2D/PathFollow2D
onready var ship_sprite : Sprite = $Path2D/PathFollow2D/ShipSprite

var screen_size: Vector2
var dialogue_finished: bool = false


export (float) var ship_movement_speed = 0.01

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	ship_movement.unit_offset += delta * ship_movement_speed
	# Repeat
	if ship_movement.unit_offset >= 1.0:
		ship_movement.unit_offset = 0.0
	if dialogue_finished and is_ship_out_of_screen():
		ship_sprite.visible = false


func is_ship_out_of_screen() -> bool:
	var rect = Rect2(Vector2.ZERO, screen_size)
	return not rect.has_point(ship_sprite.global_position)
