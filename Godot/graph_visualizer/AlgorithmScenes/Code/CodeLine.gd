tool
extends PanelContainer
class_name CodeLine

export (int) var line_index = 0
export (int) var jump_index = 0
export var focused: bool = false
export (String) var code_text = 'BFS():'
export (Resource) var effect_check;
#var effect_check2 : EffectCheck
var on_focus_effect_triggered : bool = false

onready var code_label = $MarginContainer/HBoxContainer/CodeText
onready var instruction_pointer : Sprite = $MarginContainer/HBoxContainer/InstructionPointer

const NOT_SELECTED_COLOR: Color = Color(0.24, 0.24, 0.24, 1.0);
const SELECTED_COLOR: Color = Color(0.6, 0.6, 0.24, 1.0);

var unfocused_style: StyleBox = preload("res://AlgorithmScenes/Code/default_line_code_style.tres")
var focused_style: StyleBox = preload("res://AlgorithmScenes/Code/focused_line_code_style.tres")


func _ready():
	code_label.text = code_text
	if self.effect_check:
		self.effect_check = self.effect_check.new()
		self.effect_check.code_line = self


func _process(_delta):
	if focused:
		_on_focused()
	else:
		_on_unfocus()

# TODO: debug purpose only, erase from process
func _on_focused():
	if instruction_pointer:
		instruction_pointer.visible = true
	add_stylebox_override("panel", focused_style)


# TODO: debug purpose only, erase from process
func _on_unfocus():
	self.modulate = Color(1.0, 1.0, 1.0, 1.0)
	if instruction_pointer:
		instruction_pointer.visible = false

	add_stylebox_override("panel", unfocused_style)

func focus():
	focused = true
	if self.effect_check and not self.on_focus_effect_triggered:
		self.effect_check.effect_check_on_focused()
		self.on_focus_effect_triggered = true
	_on_focused()

func unfocus():
	focused = false
	# RESET variables
	reset_effect_check()
	_on_unfocus()

# Resett side effect 
func reset_effect_check():
	self.on_focus_effect_triggered = false
	if self.effect_check:
		self.effect_check.reset()

# Given the EffectCheck for this code line,
# Get the next line that should be included
func get_next_line() -> int:
	if focused and effect_check:
		if effect_check.check_actions_correct():
			return effect_check.get_next_line()
	else:
		print("Error with line N° " + str(line_index))

	return line_index


func get_class():
	return "CodeLine"

# fors, functions, ifs and whiles perform instruction jumps
# this jumps are personalized in the effect check script for each line
func should_jump_to_line() -> bool:
	return effect_check.should_jump_to_line()

func get_line_jump() -> int:
	return jump_index
