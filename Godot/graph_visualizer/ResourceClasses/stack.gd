class_name Stack
extends Object

var _container : Array = []
var _size : int = 0

func _init():
	self._container = []
	return self

func size() -> int:
	return self._container.size()

func push(value: Object) -> void:
	self._container.append(value)

func pop() -> Object:
	assert( self._size > 0, "ERROR: Stack cannot be popped. It has no objects");
	var ret = self._container[self._container.size() - 1]  # Return last element
	self._container =  self._container.slice(0, self._container.size() - 2, 1)
	return ret
