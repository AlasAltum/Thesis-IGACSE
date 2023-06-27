extends CommandMethod

var code_block = null 

func _ready():
	code_block = parent_dialogue.world_node.get_node("HUD/CodeBlock")

# Triggered by the dialogue displayer when the player gets to this point of the dialogue
# or when the player skips the dialogue.
func show_code_instructions():
	code_block.visible = true
	# TODO: replace this by an animation

