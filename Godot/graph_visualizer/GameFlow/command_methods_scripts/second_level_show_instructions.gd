extends CommandMethod

var code_block = null  # CodeContainer

# Triggered by the dialogue displayer when the player gets to this point of the dialogue
# or when the player skips the dialogue.
func show_code_instructions():
	code_block = StoredData.world_node.get_node("HUD/CodeBlock")
	code_block.activate()
	# TODO: replace this by an animation

