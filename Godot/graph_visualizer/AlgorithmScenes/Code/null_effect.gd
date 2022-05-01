# Null effect, this is just for function initializations and skip lines.
extends EffectCheck


func _ready():
	code_line = null

#func init():
#	code_line = null

func check_actions_correct() -> bool:
	return true
