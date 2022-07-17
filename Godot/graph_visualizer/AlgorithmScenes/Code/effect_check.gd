# Class that checks for the effect of a given code line
# For each line whose effect must be checked between each
# step done by the player.
# This class must be implemented
extends Resource
class_name EffectCheck


var code_line  # : CodeLine


func _ready():
	pass

# when calling the new function
func _init():
	code_line = null


func check_actions_correct() -> bool:
	return true


# _code_line: CodeLine
func set_code_line(_code_line) -> void:
	self.code_line = _code_line

# Function called to know the next line index that will be
# Focused after this execution, this is always called
# If the user wants to execute a jump, this method must be
# overriden and its body should be get_jump_line
func get_next_line() -> int:
	_trigger_on_next_line_side_effect()
	if code_line:
		# By default, return just the next line
		return code_line.line_index + 1 
	return -1

# Function called when an instruction should jump, like fors
# gotos, whiles or if-elses
func get_jump_line() -> int:
	if code_line:
		return code_line.jump_index
	return -1

# This method may be overriden according to what is needed
func effect_check_on_focused():
	return

# This method may be overriden according to what is needed
func _trigger_on_next_line_side_effect() -> void:
	return

# By default, do nothing. This method may be overriden
func reset():
	return

