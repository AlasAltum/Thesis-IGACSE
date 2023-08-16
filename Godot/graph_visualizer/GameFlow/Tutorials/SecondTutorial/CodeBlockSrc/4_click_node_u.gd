extends EffectCheck
#       u.click()
var nodes_to_visit = []

func effect_check_on_focused():
	# Assuming StoredData.world_node is SecondTutorial
	if StoredData.world_node:
		nodes_to_visit = [
			StoredData.world_node.planet2,
			StoredData.world_node.star,
			StoredData.world_node.planet3
		]
		StoredData.selectable_nodes_indexes.append(StoredData.world_node.current_selectable_node.index)


func check_actions_correct() -> bool:
	# Get node u. if Node u is selected return true
	if StoredData.world_node and StoredData.world_node.u_node and StoredData.world_node.u_node.selected:
		return true
	return false
