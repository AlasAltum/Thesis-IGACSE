class_name AbstractTestScript
extends Node
# Abstract class, wil lbe used by TestManagers
# to check if the user was executing correct actions during 
# the test phase
var num_right_actions = 0
var num_incorrect_actions = 0
var first_click = true
var first_click_time = 0.0
var last_click_time = 0.0

func is_first_node() -> bool:
	return StoredData.get_selected_nodes().size() == 0

func on_node_click(node):
	print('node ' + str(node.index) + ' was pressed')
	if first_click:
		# First time
		first_click_time = OS.get_ticks_msec()
		first_click = false
	last_click_time = OS.get_ticks_msec()


func was_node_clicked_action_correct(node) -> bool:
	return false

func get_errors() -> int:
	return num_incorrect_actions

func get_correct_answers() -> int:
	return num_right_actions

func get_time_between_first_and_last_click():
	return last_click_time - first_click_time
