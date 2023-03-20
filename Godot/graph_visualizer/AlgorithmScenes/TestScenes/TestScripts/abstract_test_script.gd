class_name AbstractTestScript
extends Node
# Abstract class, wil lbe used by TestManagers
# to check if the user was executing correct actions during 
# the test phase


func is_first_node() -> bool:
	return StoredData.get_selected_nodes().size() == 0

func on_node_click(node):
	pass

