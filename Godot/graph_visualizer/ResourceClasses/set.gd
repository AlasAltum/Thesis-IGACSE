class_name Set
extends Object

var _container : Dictionary = {}
var _size : int = 0

func _init():
	self._container = {}
	return self

func size() -> int:
	return self._container.size()

func add(value: Object) -> void:
	self._container[value] = null

func contains(value: Object) -> bool:
	return value in self._container

func erase(value: Object) -> void:
	self._container.erase(value)
