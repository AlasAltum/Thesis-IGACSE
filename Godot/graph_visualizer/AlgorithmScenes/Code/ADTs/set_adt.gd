class_name SetADT
extends ADT


func _init():
	self.representation = preload("res://AlgorithmScenes/Screen/ADT/Queue/QueueRepresentation.tscn").instance()
	pass

func allows_object_adition() -> bool:
	return true

func _ready():
	data = []
	return

func get_representation() -> ADTRepresentation:
	if not self.representation:
		return self.create_representation()
	return self.representation

func create_representation() -> ADTRepresentation:
	self.representation = preload("res://AlgorithmScenes/Screen/ADT/Queue/QueueRepresentation.tscn").instance()
	return self.representation

static func get_type() -> String:
	return "Set"

func _data_as_string():
	if data.size() > 0:
		var ret = ""
		for index in range(data.size() - 1):
			ret += str(data[index].as_string() + ", ")
		ret += str(data[-1].as_string())
		return ret
	return ""

func as_string() -> String:
	var format_string = "Set{{data}}"
	return format_string.format({"data": _data_as_string()})

func add_data(incoming_data):
	if not incoming_data in self.data:
		data.append(incoming_data)

func erase(incoming_data):
	data.erase(incoming_data)

func substract_data(incoming_data):
	data.erase(incoming_data)

func size() -> int:
	return data.size()
