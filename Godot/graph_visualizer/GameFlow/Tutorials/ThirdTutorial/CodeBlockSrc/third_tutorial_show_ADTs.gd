extends CommandMethod

var code_block = null  # CodeContainer


func fade_stack_queue_and_show_stack():
	if StoredData.world_node:
		var anim_player = StoredData.world_node.get_node("%AnimationPlayer")
		anim_player.play("ShowStack")


func show_queue_animation():
	if StoredData.world_node:
		var anim_player = StoredData.world_node.get_node("%AnimationPlayer")
		anim_player.play("ShowQueue")

