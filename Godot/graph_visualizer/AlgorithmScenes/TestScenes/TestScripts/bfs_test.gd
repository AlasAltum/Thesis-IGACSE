class_name BFSTest
extends AbstractTestScript

var queue
var nodes_that_must_be_pressed_next: Array = []
var num_right_actions = 0
var num_incorrect_actions = 0

func _ready():
	queue = QueueForTesting.new()
	for _node in StoredData.nodes:
		_node.connect("node_selected", self, "on_node_click")


func incoming_node_is_neighbor_of_last_press(incoming_node: AGraphNode) -> bool:
	var last_node_index = queue.get_last().index
	var edges = incoming_node.get_edges()
	# pairs<node_index <int>, weight <float>>:
	for _edge in edges:
		var neighbor_index = _edge[0]
		if neighbor_index == last_node_index:
			return true
	return false


# @param node: AGraphNode
func on_node_click(node):
	if was_node_clicked_action_correct(node):
		num_right_actions += 1
		node.representation.set_selected()
	else:
		num_incorrect_actions += 1
		node.representation.set_unselected()
		# TODO: show error to user

func was_node_clicked_action_correct(node) -> bool:
	# If node is a valid selectable node during a BFS algorithm
	# if it was correct
	# Force the user to start with node 0
	var cond_a = .is_first_node() and node.index == 0
	var cond_b = queue.node_is_in_corresponding_level(node)
	if cond_a or cond_b:
		queue.push(node)
		return true

	return false
