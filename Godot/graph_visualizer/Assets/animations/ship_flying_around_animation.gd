extends Node2D

onready var ship_sprite: Sprite = $ShipSprite

export (float) var radius = 500.0
export (float) var angle = 0.0
export (float) var rotation_speed_factor = 3.2

const rotation_offset = PI

func _process(delta):
	ship_sprite.position = radius * Vector2(cos(angle), sin(angle))
	angle -= rotation_speed_factor * delta
	ship_sprite.rotation = angle + rotation_offset

