extends CommandMethod

var code_block = null  # CodeContainer


# Triggered by the dialogue displayer when the player gets to this point of the dialogue
# or when the player skips the dialogue.
func show_code_instructions():
	code_block = StoredData.world_node.get_node("HUD/CodeBlock")
	code_block.activate()
	# TODO: replace this by an animation

# Will show the instruction pointer of the first instruction
# of the code block 
func show_pointer_of_first_instruction():
	if code_block:
		var first_instruction = code_block.get_node("LinesContainer/PanelContainer00")
		# TODO: make pointer of first instruction visible
		
