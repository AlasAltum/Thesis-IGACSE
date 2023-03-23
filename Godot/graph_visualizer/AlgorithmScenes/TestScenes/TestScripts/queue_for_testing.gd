class_name StackForTesting
extends Object

"""
This class is intended to verify the answers from an user
during a test phase.
A typical Stack may not be used since there are many correct answer
for the same graph G. This class is capable of checking if the
answers given by an user are correct.
"""

"""
Given graph G:

0 => 1
1 => 6, 7, 2
7 => 5, 4, 3
4 => 9

There are many possible answers, for example:
	
0 -> 1 -> 7 -> 4 -> 6 -> 2 -> 5 -> 3
But another option is:
0 -> 1 -> 6 -> 2 -> 7 -> 5 -> 3 -> 4 -> 9
In this last example, the DFS could have the same result as a BFS,
that happens because the depth of this graph was relatively low
"""

var _container : Array = []

func _init():
	self._container = []
	return self

# @parameter node: AGraphNode, the node that was pressed
# check if the pressed node is in the corresponding level
# The corresponding level is determined by knowing how much
# nodes are in the current level. If all nodes in that level
# are pressed, then the node should be in the next level
# Since this is a stack, the current level is the last one  
func node_is_in_corresponding_level(node) -> bool:
	return node in get_last_level()

func pop_element_from_all_levels(node):
	var new_container = []
	for _level in self._container:
		if node in _level or node.selected:
			_level.erase(node)
			# We do not want to erase levels while iterating in the container
			# So we just filter these levels in a new container and then reassign it
		if _level.size() > 0:
			new_container.append(_level)

	self._container = new_container

func push_level(values: Array):
	self._container.append(values)


## Helper methods ##

func size() -> int:
	return self._container.size()

func last_is_multilevel() -> bool:
	var last_element = get_last_level()
	if last_element is Array:
		return true
	return false

func first_is_multilevel() -> bool:
	var first_element = get_front_level()
	if first_element is Array:
		return true
	return false

func node_is_in_last_level(node) -> bool:
	if self.is_not_empty():
		return node in get_last_level()

	# If the queue is empty, the node may not be in the last level
	return false

func get_front_level():
	return self._container[0]

func get_last_level():
	return self._container[self.size() - 1]


func push(value: Object) -> void:
	self._container.append(value)

func pop_element_from_last_level() -> Object:
	assert( self._size > 0, "ERROR: Stack cannot be popped. It has no objects");
	var ret = self._container[self._container.size() - 1]  # Return last element
	
	
	self._container =  self._container.slice(0, self._container.size() - 2, 1)
	return ret

func pop_element_from_first_level(node):
	# if the first level of the queue is multilevel, just remove the node from the multilevel
	# elsewise, if the first level is a single node, just remove it
	self.get_front_level().erase(node)
	if self.get_front_level().size() == 0:
		self._container = self._container.slice(1, self._container.size() - 1, 1)

func is_empty() -> bool:
	return self.size() == 0 or (self.size() == 1 and self._container[0].size() == 0)

func is_not_empty() -> bool:
	return not is_empty()

