class_name CommandMethod
extends Resource

# The dialogue player may trigger function calls from text.
# A command Method is a string that is surrounded by curly braces
# like {foo}, this will trigger the foo method in the command method script
# that is bound to the dialogue instance in the editor.

var parent_dialogue = null #: DialogueDisplayer

func _ready():
	if parent_dialogue:
		var world_node = parent_dialogue.get_parent_control()
