class_name CommandMethod
extends Resource

# The dialogue player may trigger function calls from text.
# A command Method is a string that is surrounded by curly braces
# like {foo}, this will trigger the foo method in the command method script
# that is bound to the dialogue instance in the editor.

var executed_command_methods = [] #: Array
var parent_dialogue = null #: DialogueDisplayer


func execute_command(command: String, allow_repetition = false) -> void:
	if command in executed_command_methods and not allow_repetition:
		return

	executed_command_methods.append(command)
	self.call(command)
