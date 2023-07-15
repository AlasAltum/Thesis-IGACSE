extends CommandMethod

var code_block = null  # CodeContainer


# Triggered by the dialogue displayer when the player gets to this point of the dialogue
# or when the player skips the dialogue.
func show_code_instructions():
	code_block = StoredData.world_node.get_node("HUD/CodeBlock")
	code_block.activate()
	# TODO: replace this by an animation

# Show the instruction pointer of the first instruction
# of the code block 
func show_pointer_of_first_instruction():
	if code_block:
		var first_instruction = code_block.get_node("LinesContainer/PanelContainer0")
#		# TODO: make pointer of first instruction visible
		yield(code_block.get_tree().create_timer(1.2), "timeout")
		first_instruction.focus()
		NotificationManager.allow_code_advance = true


func make_dialogue_buttons_invisible():
	if not parent_dialogue:
		printerr("No parent dialogue detected!")
		breakpoint

	var skip_button = parent_dialogue.get_node("MarginContainer/VBoxContainer/HBoxContainer/SkipButton")
	var next_button = parent_dialogue.get_node("MarginContainer/VBoxContainer/HBoxContainer/NextButton")
	skip_button.visible = false
	next_button.visible = false

