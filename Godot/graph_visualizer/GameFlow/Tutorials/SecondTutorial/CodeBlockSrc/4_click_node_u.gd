extends EffectCheck
#       u.click()

func check_actions_correct() -> bool:
	# Get node u. if Node u is selected return true
	if StoredData.world_node.u_node.selected:
		return true
	return false
