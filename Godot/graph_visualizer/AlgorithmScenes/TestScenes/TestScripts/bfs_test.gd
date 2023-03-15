class_name BFSTest
extends AbstractTestScript

var queue: Queue

func _ready():
	queue = Queue.new()

func incoming_node_is_neighbor_of_last_press(incoming_node: AGraphNode) -> bool:
	var last_node_index = queue.get_last().index
	var edges = incoming_node.get_edges()
	# pairs<node_index <int>, weight <float>>:
	for _edge in edges:
		var neighbor_index = _edge[0]
		if neightbor_index == last_node_index:
			return true
	return false


func was_node_clicked_action_correct(node: AGraphNode) -> bool:
	# If node is a valid selectable node during a BFS algorithm
	# if it was correct
	if .is_first_node():
		queue.push(node)
		return true
	else:
		if 
		var selected_nodes = StoredData.get_selected_nodes()
		
		
	return true
