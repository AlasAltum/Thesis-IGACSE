class_name AbstractTestScript
extends Node
# Abstract class, wil lbe used by TestManagers
# to check if the user was executing correct actions during 
# the test phase

var selected_nodes_in_order : Array = []

func add_select_action_to_list(node): 
	selected_nodes_in_order.append(node)

func is_first_node() -> bool:
	return StoredData.get_selected_nodes().size() == 0
