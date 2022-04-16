extends ADT
class_name QueueADT

var data : Array = []  # Array of Node2D

func _ready():
	pass

static func get_type() -> String:
	return "Queue"

func data_as_string():
	if data.size() > 0:
		var ret = ""
		for index in range(data.size() - 1):
			ret += str(data[index].as_variable() + ", ")
		ret += str(data[-1].as_variable())
		return ret
	return ""

func as_variable() -> String:
	var format_string = "Queue({data})"
	# Using the 'format' method, replace the 'str' placeholder
	return format_string.format({"data": data_as_string()})

func add_data(incoming_data):
	data.append(incoming_data)

func get_object() -> Object:
	return self
