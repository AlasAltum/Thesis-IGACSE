class_name QueueForTesting
extends Object

"""
This class is intended to verify the answers from an user
during a test phase.
A typical Queue may not be used since the answers here
an not the same for the same graph G. This happens because
there are multiple correct answers. This class is capable
of checking if the current answer is correct.
"""

"""
This levels_queue will contain a queue with levels
like a tree with height. i.e. if we have a graph like this:

0 => 1 => 2, 3, 4
3 => 5
4 => 5

The user should press 0, 1 and then the user is free to press 2, 3 or 4
These 3 options are correct, but then, after pressing 2, 3 and 4, the user
must press 5.
So the queue would look like:

| 0 |
| 1 |
| 2 | 3 | 4 |    # multilevel
| 5 |

Anyway, this queue may not be constructed at the start of the level.
It should be constructed while the user is pressing inputs, because
if the graph is not a tree, the structure is not deterministic at
initialization time.
"""

var _container : Array = []

func _init():
	self._container = []
	return self

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

# In theory is the same as push
# But this is more explicit
func push_level(values: Array):
	self._container.append(values)

func get_front_level():
	return self._container[0]

func get_last_level():
	return self._container[self.size() - 1]

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

# @parameter node: AGraphNode, the node that was pressed
# check if the pressed node is in the corresponding level
# The corresponding level is determined by knowing how much
# nodes are in the present level. If all nodes in that level
# are pressed, then the node should be in the next level 
func node_is_in_corresponding_level(node) -> bool:
	return node in get_front_level()
