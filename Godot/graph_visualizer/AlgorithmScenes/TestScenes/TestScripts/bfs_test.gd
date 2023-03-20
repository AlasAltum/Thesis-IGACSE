class_name BFSTest
extends AbstractTestScript

var queue # : QueueForTesting
var nodes_that_must_be_pressed_next: Array = []
var num_right_actions = 0
var num_incorrect_actions = 0
var first_node = null

func _ready():
	queue = QueueForTesting.new()
#	for _node in StoredData.nodes:
#		_node.connect("node_selected", self, "on_node_click")
	# Get first node and add it to the queue
	for _node in StoredData.nodes:
		if _node.index == 0:
			queue.push_level([_node])
			first_node = _node
			break


func incoming_node_is_neighbor_of_last_press(incoming_node: AGraphNode) -> bool:
	var last_node_index = queue.get_last().index
	var edges = incoming_node.get_edges()
	# pairs<node_index <int>, weight <float>>:
	for _edge in edges:
		var neighbor_index = _edge[0]
		if neighbor_index == last_node_index:
			return true
	return false

func is_first_node_process_it(node):
	if node == first_node:
		queue.pop_element_from_all_levels(node)
		_add_non_selected_neighbors_of_node_to_queue(node)
		return true
	return false

# @param node: AGraphNode
func on_node_click(node):
	print('node ' + str(node.index) + ' was pressed')
	if was_node_clicked_action_correct(node):
		queue.pop_element_from_all_levels(node) # Maybe from the whole queue
		# Add the neighbors of the node which have not been selected yet to the queue
		_add_non_selected_neighbors_of_node_to_queue(node)
		num_right_actions += 1
		_debug_print_nodes_indexes_in_queue()
		return

	# If the user clicked on a node that was not correct
	num_incorrect_actions += 1
	node.unselect_node()
	# TODO: show error to user

func _add_non_selected_neighbors_of_node_to_queue(node):
	var neighbors: Array = node.get_non_selected_neighbors()
	if neighbors.size() > 0:
		queue.push_level(neighbors)



func was_node_clicked_action_correct(node) -> bool:
	# If node is a valid selectable node during a BFS algorithm
	# if it was correct
	# Force the user to start with node 0
	var cond_a = .is_first_node() and node.index == 0
	var cond_b = queue.node_is_in_corresponding_level(node)
	if cond_a or cond_b:
		return true

	return false

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

