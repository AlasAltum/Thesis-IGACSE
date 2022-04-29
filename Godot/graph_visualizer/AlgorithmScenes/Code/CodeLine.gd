tool
extends PanelContainer
class_name CodeLine


export (int) var line_index = 0
export (int) var jump_index = 0
export var focused: bool = false
export (String) var code_text = 'BFS():'
export (Resource) var effect_check;

onready var code_label = $MarginContainer/HBoxContainer/CodeText
onready var instruction_pointer : Sprite = $MarginContainer/HBoxContainer/InstructionPointer

const NOT_SELECTED_COLOR: Color = Color(0.24, 0.24, 0.24, 1.0);
const SELECTED_COLOR: Color = Color(0.6, 0.6, 0.24, 1.0);

var unfocused_style: StyleBox = preload("res://AlgorithmScenes/Code/default_line_code_style.tres")
var focused_style: StyleBox = preload("res://AlgorithmScenes/Code/focused_line_code_style.tres")


func _ready():
	code_label.text = code_text
	if self.effect_check:
		self.effect_check = effect_check.new()
		if self.effect_check:
			self.effect_check.set_code_line(self)

func _process(_delta):
	if focused:
		_on_focused()
	else:
		not_focused()

# TODO: debug purpose only, erase
func _on_focused():
	if instruction_pointer:
		instruction_pointer.visible = true

	add_stylebox_override("panel", focused_style)


# TODO: debug purpose only, erase
func not_focused():
	self.modulate = Color(1.0, 1.0, 1.0, 1.0)
	if instruction_pointer:
		instruction_pointer.visible = false

	add_stylebox_override("panel", unfocused_style)

func focus():
	focused = true
	_on_focused()

func unfocus():
	focused = false
	not_focused()


# Given the EffectCheck for this code line,
# Get the next line that should be included
func get_next_line() -> int:
	if focused and effect_check:
		if effect_check.check_actions_correct():
			return effect_check.get_next_line()
	else:
		print("Error with line N° " + str(line_index))

	return line_index

# Override
func get_class():
	return "CodeLine"

func should_jump_to_line() -> bool:
	return effect_check.should_jump_to_line()

func get_line_jump() -> int:
	return jump_index
