extends EffectCheck


func _ready():
	pass


static func check_actions_correct() -> bool:
	if StoredData.has_variable("q"):
		print(StoredData.get_data_type_of_variable("q"))
		if "Queue" in StoredData.get_data_type_of_variable("q"):
			return true
	return false
