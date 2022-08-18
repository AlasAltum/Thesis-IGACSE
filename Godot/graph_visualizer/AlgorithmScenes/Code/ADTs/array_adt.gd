class_name ArrayADT
extends ADT

# Abstract Data Type that represents an array

func _init():
	self.representation = preload("res://AlgorithmScenes/Screen/ADT/Array/ArrayRepresentation.tscn").instance()


func get_representation() -> ADTRepresentation:
	if not self.representation:
		return self.create_representation()
	return self.representation


func create_representation() -> ADTRepresentation:
	self.representation = preload("res://AlgorithmScenes/Screen/ADT/Array/ArrayRepresentation.tscn").instance()
	return self.representation


static func get_type() -> String:
	return "Array"


func _data_as_string():
	# TODO: Data is having null elements.
	if data.size() > 0:
		var ret = ""
		for index in range(data.size() - 1):
			ret += str(data[index].as_string() + ", ")
		ret += str(data[data.size() - 1].as_string())
		return ret
	return ""


func as_string() -> String:
	var format_string = "[{data}]"
	return format_string.format({"data": _data_as_string()})


func add_data(incoming_data):
	if incoming_data != null:
		self.data.append(incoming_data)
		representation.add_data(incoming_data)
	else:
		printerr("Adding invalid data")

func first():
	var ret = data[0]
	representation.remove_node(ret)
	data.remove(0)
	return ret
