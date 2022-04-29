extends EffectCheck


func _ready():
	pass


func check_actions_correct() -> bool:
	if StoredData.has_variable("q") and StoredData.has_variable("t"):
		if StoredData.heap_dictionary["q"].as_string() == "Queue(Node(0))":
			return true
	return false
