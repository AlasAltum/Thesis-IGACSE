extends Node2D
# class_name StoredData

enum mov_status {SELECT = 0, DRAG = 1}

var status : int = mov_status.DRAG;
var nodes : Array = []  # PoolAGraphNodeArray
var heap : DebugBlock
var json = {
	"n": 3,
	"matrix": [],
}

const status_map = {
	"DRAG": mov_status.DRAG,
	"SELECT": mov_status.SELECT
}


func get_status():
	return status

func set_status(incoming_state: String):
	self.status = status_map[incoming_state]

func add_variable(var_name, data):
	if heap:
		heap.add_variable(var_name, data)

func get_selected_nodes() -> Array:
	var selected_nodes : Array = []
	for _node in self.nodes:
		if _node.selected:
			selected_nodes.append(_node)

	return selected_nodes
