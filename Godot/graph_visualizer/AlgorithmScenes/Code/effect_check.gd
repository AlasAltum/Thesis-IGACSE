# This class is supposed to be a parent class
# For each line whose effect must be checked between each
# step done by the player.
extends Resource
class_name EffectCheck

export (String) var line_text

func _ready():
	pass

static func check_actions_correct() -> bool:
	print("Abstract class application, this should not be printed")
	return true
