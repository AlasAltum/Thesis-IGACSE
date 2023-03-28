class_name BFSTest
extends AbstractTestScript

var queue # : QueueForTesting
var nodes_that_must_be_pressed_next: Array = []

var first_node = null

signal all_nodes_pressed

func _ready():
	queue = QueueForTesting.new()
	self.connect("all_nodes_pressed", self, "on_all_nodes_pressed")
	_add_first_node_to_stack()

func _add_first_node_to_stack():
	# Get first node and add it to the stack
	for _node in StoredData.nodes:
		if _node.index == 0:
			queue.push_level([_node])
			first_node = _node
			return

# @param node: AGraphNode
func on_node_click(node):
	.on_node_click(node)
	if was_node_clicked_action_correct(node):
		queue.pop_element_from_all_levels(node)
		# Add the neighbors of the node which have not been selected yet to the queue
		_add_non_selected_neighbors_of_node_to_queue(node)
		num_right_actions += 1
		_debug_print_nodes_indexes_in_queue()
		# We make a deferred notification because we want to end this method first
		# Since this method itself is triggered by a signal
		if StoredData.get_selected_nodes().size() == StoredData.number_of_nodes:
			call_deferred("notify_all_nodes_pressed")
		return

	# If the user clicked on a node that was not correct
	num_incorrect_actions += 1
	node.unselect_node()
	# TODO: show error to user

func was_node_clicked_action_correct(node) -> bool:
	# If node is a valid selectable node during a BFS algorithm
	# if it was correct
	# Force the user to start with node 0
	var cond_a = .is_first_node() and node.index == 0
	var cond_b = queue.node_is_in_corresponding_level(node)
	if cond_a or cond_b:
		return true

	return false

func is_first_node_process_it(node):
	if node == first_node:
		queue.pop_element_from_all_levels(node)
		_add_non_selected_neighbors_of_node_to_queue(node)
		return true
	return false

func _add_non_selected_neighbors_of_node_to_queue(node):
	var neighbors: Array = node.get_non_selected_neighbors()
	if neighbors.size() > 0:
		queue.push_level(neighbors)

func _debug_print_nodes_indexes_in_queue():
	print("======================")
	for _level in queue._container:
		if _level is Array:
			var nodes_indexes = []
			for _node in _level:
				nodes_indexes.append(_node.index)	
			print(nodes_indexes)

		else:
			print(_level.index)
	print("======================")

func notify_all_nodes_pressed():
	emit_signal("all_nodes_pressed")

