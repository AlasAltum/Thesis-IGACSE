class_name TestManager
extends GraphManager

# Class that manages the testing phase. Here, the usere must recreate
# the steps of an algorithm like BFS, so the user must press the nodes
# in a valid BFS order 

export (Array) var events = []
var map_name_to_test_script = {
	"BFS": BFSTest.new(),
	"DFS": DFSTest.new(),
	"MST": load("res://AlgorithmScenes/TestScenes/TestScripts/mst_test.gd"),
}

var unique_id: String = ""  #  = (str) OS.get_unique_id()
var test_script = null
var selected_nodes_in_order : Array = []


func _ready():
	# Super.ready() is called, which creates a new graph
	_initialize_test_game_mode()
	test_script = map_name_to_test_script[self.level_name]
	add_child(test_script)
	test_script.connect("all_nodes_pressed", self, "on_all_nodes_pressed")
	# test_script will have the logic to check if an action was correct
	self.unique_id = str( OS.get_unique_id() )
	self.start_time = OS.get_ticks_msec()
	self.start_os_datetime = str( OS.get_datetime() )
	# Erase from string the starting and ending characters
	if start_os_datetime.begins_with("{") and start_os_datetime.ends_with("}"):
		start_os_datetime = start_os_datetime.substr(1, start_os_datetime.length() - 2)


func _get_current_time() -> String:
	return str(OS.get_ticks_msec() - self.start_time)

# In this mode, all nodes may be selected since the beginning
# The user must press the nodes in a valid order 
func _initialize_test_game_mode():
	# Make all nodes selectable
	# node type: AGraphNode
	for node in StoredData.nodes:
		StoredData.selectable_nodes.append(node.index)
		node.connect("node_selected", self, "_store_node_selected_event")

func _store_node_selected_event(node):
	selected_nodes_in_order.append(node)
	var correct_or_wrong : String = test_script.on_node_click(node)
	var datetime_unique_id_str: String = str(OS.get_ticks_msec())
	var new_entry: Dictionary = {
		"eventid": correct_or_wrong,
		"timestamp": datetime_unique_id_str,
		"deviceid": unique_id,
		"intype": "NodePress",
	}
	events.append(new_entry)


func on_all_nodes_pressed():
	var finished_popup: WindowDialog = $CanvasLayer/FinishedPopup

	var errors = test_script.get_errors()
	var correct = test_script.get_correct_answers()
	var total_time = test_script.get_time_between_first_and_last_click()

	# Send summary
	var event_id_str : String = self.level_name + " Finished"
	var timestamp = str(OS.get_unix_time())
	var in_type_data = "errors: {errors}, correct answers: {correct}, total_time: {total_time}, datetime: {datetime}".format({"errors": errors, "correct": correct, "total_time": total_time, "datetime": start_os_datetime})
	var new_entry: Dictionary = {
		"eventid": event_id_str,
		"timestamp": timestamp,
		"deviceid": unique_id,
		"intype": in_type_data,
	}
	print(new_entry)
	events.append(new_entry)
	finished_popup.popup()
	# Convert the dictionary to JSON String
	var request_data: String = JSON.print(events)
	if StoredData.allow_sending_request:
		send_http_request(request_data)


func send_http_request(request_data: String):
	var http_request = HTTPRequest.new()
	self.add_child(http_request)
	http_request.connect("request_completed", self, "_http_request_completed")
	# Perform a POST request. The URL below returns JSON as of writing.

	if not request_data.begins_with("[") and not request_data.ends_with("]"):
		request_data = "[" + request_data + "]"

	print("About to send the following request: " + request_data)
	var error = http_request.request(StoredData.API_URL, [], true, HTTPClient.METHOD_POST, request_data)
	if error != OK:
		push_error("An error occurred in the HTTP request.")

func _http_request_completed():
	print("Request sent")



func _on_TestPlayer_ready():
	$CanvasLayer/TestPlayer.play("ShowInstructionsAndThenNoes")
