extends EffectCheck
# while q.is_not_empty()

func _ready():
	pass


static func check_actions_correct() -> bool:
	if StoredData.has_variable("q") and StoredData.has_variable("t"):
		if StoredData.heap_dictionary["q"].as_variable() == "Queue()":
			StoredData.execute_jump()
			return true
	return false
