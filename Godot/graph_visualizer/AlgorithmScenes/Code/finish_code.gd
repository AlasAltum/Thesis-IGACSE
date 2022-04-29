extends EffectCheck
# finish code

func _ready():
	pass

func _init():
	code_line = null

# TODO: Add notification
func side_effect() -> void:
	print("Code Finished!")

func check_actions_correct() -> bool:
	return false
