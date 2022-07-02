class_name StackADT
extends ADT

var data : Array = []  # Array of Node2D

#func _ready():
#	self.representation = StackRepresentation.new()

func _init():
	self.representation = preload("res://AlgorithmScenes/Screen/ADT/Stack/StackRepresentation.tscn").instance()


static func get_type() -> String:
	return "Stack"

# Return the internal data of the stack as a string
func _data_as_string():
	if data.size() > 0:
		var ret = ""
		# Add data as the form (0, 1, 2, ...)
		for index in range(data.size() - 1):
			ret += str(data[index].as_string() + ", ")
		ret += str(data[-1].as_string())
		return ret
	return ""

func as_string() -> String:
	var format_string = "Stack({data})"
	# Using the 'format' method, replace the 'str' placeholder
	return format_string.format({"data": _data_as_string()})

func add_data(incoming_data):
	data.append(incoming_data)

func top():
	var ret = data[data.size() - 1]
	data.remove(data.size() - 1)
	return ret

