# Null effect, this is just for function initializations and skip lines.
extends EffectCheck


func _ready():
	# TODO: hacer aparecer una cola y llevarla al heap
	pass

static func check_actions_correct() -> bool:
	StoredData.add_variable("q", "Queue[]")
	return true

