class_name Queue
extends Object

var _container : Array = []

func _init():
	self._container = []
	return self

func size() -> int:
	return self._container.size()

func push(value: Object) -> void:
	self._container.append(value)

func get_front():
	return self._container[0]

func get_last():
	return self._container[self.size() - 1]

func pop() -> Object:
	assert( self.size() > 0, "ERROR: Queue cannot be popped. It has no objects");
	var ret = self._container[0]
	self._container =  self._container.slice(1, self._container.size() - 1, 1)
	return ret

func is_empty() -> bool:
	return self.size() == 0

func is_not_empty() -> bool:
	return not is_empty()

