extends EffectCheck


func _ready():
	pass


static func check_actions_correct() -> bool:
	if StoredData.has_variable("q") and StoredData.has_variable("t"):
		print(StoredData.heap_dictionary["q"].as_variable())
		if StoredData.heap_dictionary["q"].as_variable() == "Queue(Node(0))":
			return true
	return false
