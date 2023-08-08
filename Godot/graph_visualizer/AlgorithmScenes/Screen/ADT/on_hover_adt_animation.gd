extends Node2D

onready var animation_player: AnimationPlayer = $AnimationPlayer

func play_animation() -> void:
	animation_player.stop()
	animation_player.play("HoverAnimation")

func stop_animation() -> void:
	animation_player.stop()

