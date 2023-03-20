class_name TestManager
extends GraphManager

# Class that manages the testing phase. Here, the usere must recreate
# the steps of an algorithm like BFS, so the user must press the nodes
# in a valid BFS order 

export (Array) var events = []
export (Dictionary) var map_name_to_test_script = {
	"BFS": BFSTest.new(),
	"DFS": DFSTest.new(),
	"MST": load("res://AlgorithmScenes/TestScenes/TestScripts/mst_test.gd"),
}

var test_script = null
var selected_nodes_in_order : Array = []

func _ready():
	# Super.ready() is called, which creates a new graph
	_initialize_test_game_mode()
	test_script = map_name_to_test_script[self.level_name]
	add_child(test_script)
	# test_script will have the logic to check if an action was correct


# In this mode, all nodes may be selected since the beginning
# The user must press the nodes in a valid order 
func _initialize_test_game_mode():
	# Make all nodes selectable
	for node in StoredData.nodes:
		StoredData.selectable_nodes.append(node.index)
		node.connect("node_selected", self, "_store_node_selected_event")

func _store_node_selected_event(node):
	selected_nodes_in_order.append(node)
	test_script.on_node_click(node)

	var new_entry: Dictionary = {
		"eventid": "NodePress",
		"timestamp": OS.get_datetime(),
		"deviceid": OS.get_unique_id(),
		"intype": "NodePress"
	}
	events.append(new_entry)

