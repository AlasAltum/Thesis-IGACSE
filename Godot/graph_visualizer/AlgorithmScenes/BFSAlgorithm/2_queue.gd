# Null effect, this is just for function initializations and skip lines.
extends EffectCheck


func _ready():
	# TODO: hacer aparecer una cola y llevarla al heap
	pass


static func check_actions_correct() -> bool:
	if StoredData.has_variable("q"):
		if "Queue" in StoredData.get_data_type_of_variable("q"):
			return true
	return false
