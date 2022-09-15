class_name QueueADT
extends ADT

# RepresentationClass: QueueRepresentation


func _init():
	self.representation = preload("res://AlgorithmScenes/Screen/ADT/Queue/QueueRepresentation.tscn").instance()

func allows_object_adition() -> bool:
	return true

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
	return format_string.format({"data": _data_as_string()})

func add_data(incoming_data):
	data.append(incoming_data)
	representation.add_node(incoming_data)


func top():
	var ret = data[0]
	representation.remove_node(ret)
	data.remove(0)
	return ret
