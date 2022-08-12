# Class that checks for the effect of a given code line
# For each line whose effect must be checked between each
# step done by the player.
# This class must be implemented
extends Resource
class_name EffectCheck

var code_line: CodeLine

func _ready():
	pass

func _init():
	code_line = null

# Code being executed constantly to check whether the actions
# of the player are correct
func check_actions_correct() -> bool:
	return true


# @param: CodeLine _code_line: the line to be set
# Set the code line of the current effect check
func set_code_line(_code_line: CodeLine) -> void:
	self.code_line = _code_line

# Function called to know the next line index that will be
# Focused after this execution, this is always called
# If the user wants to execute a jump, this method must be
# overriden and its body should call get_jump_line
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

# Execute side effect when the code line that contains 
# this effect check is focused
func effect_check_on_focused() -> void:
	return

# Execute side effect when the code line that contains
# this effect check was executed and the next line is focused
func _trigger_on_next_line_side_effect() -> void:
	return

# By default, do nothing. This method may be overriden
# Reset to default variables of a given effect check to allow loops
func reset() -> void:
	return

