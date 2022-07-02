class_name QueueADT
extends ADT

# RepresentationClass: QueueRepresentation
var data : Array = []  # Array of AGraphNode


func _init():
	self.representation = preload("res://AlgorithmScenes/Screen/ADT/Queue/QueueRepresentation.tscn").instance()

func init():
	self.representation = preload("res://AlgorithmScenes/Screen/ADT/Queue/QueueRepresentation.tscn").instance()

func get_representation() -> ADTRepresentation:
	if not self.representation:
		return self.create_representation()
	return self.representation

func create_representation() -> ADTRepresentation:
	self.representation = preload("res://AlgorithmScenes/Screen/ADT/Queue/QueueRepresentation.tscn").instance()
	return self.representation


static func get_type() -> String:
	return "Queue"

func _data_as_string():
	if data.size() > 0:
		var ret = ""
		for index in range(data.size() - 1):
			ret += str(data[index].as_string() + ", ")
		ret += str(data[-1].as_string())
		return ret
	return ""

func as_string() -> String:
	var format_string = "Queue({data})"
	# Using the 'format' method, replace the 'str' placeholder
	return format_string.format({"data": _data_as_string()})

func add_data(incoming_data):
	data.append(incoming_data)
	representation._add_node(incoming_data)


func top():
	var ret = data[0]
	self.representation._remove_node(ret)
	data.remove(0)
	# QueueRepresentation
	return ret
