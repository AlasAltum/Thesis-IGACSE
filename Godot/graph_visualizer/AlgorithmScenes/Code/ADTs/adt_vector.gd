class_name ADTVector
extends Resource

# Tuple that contains <ADT, index, name>

var adt: ADT setget set_data, get_data
var index: int setget set_index, get_index
var name: String setget set_name, get_name
var representation: ADTRepresentation setget set_representation, get_representation


func _init(_adt: ADT, _index: int, _name: String) -> void:
	index = _index
	name = _name
	adt = _adt
	representation = adt.get_representation()

func set_data(_adt: ADT):
	adt = _adt

func get_data() -> ADT:
	return adt

func set_index(_index: int):
	index = _index

func get_index():
	return index

func set_name(_name: String):
	name = _name

func get_name():
	return name

func set_representation(_rep):
	representation = _rep

func get_representation():
	return adt.get_representation()
