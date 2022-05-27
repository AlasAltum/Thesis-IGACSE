class_name ADTVector
extends Resource

# Tuple that contains <ADT, index, name>

var adt: ADT 
var index: int
var name: String


func _init(_adt: ADT, _index: int, _name: String) -> void:
	adt = _adt
	index = _index
	name = _name
