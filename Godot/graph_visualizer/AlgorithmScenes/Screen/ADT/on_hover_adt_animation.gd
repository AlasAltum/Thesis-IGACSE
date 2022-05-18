extends Node2D

onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	pass # Replace with function body.

func play_animation() -> void:
	animation_player.stop()
	animation_player.play("HoverAnimation")

func stop_animation() -> void:
	animation_player.stop()

