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
#	var stylebox = get_stylebox("panel")
#	print(stylebox)
#	stylebox.bg_color = SELECTED_COLOR


# TODO: debug purpose only, erase
func not_focused():
	self.modulate = Color(1.0, 1.0, 1.0, 1.0)
	if instruction_pointer:
		instruction_pointer.visible = false

	add_stylebox_override("panel", unfocused_style)
#	var stylebox = get_stylebox("panel")
#	stylebox.bg_color = NOT_SELECTED_COLOR

func focus():
	focused = true
	_on_focused()

func unfocus():
	focused = false
	not_focused()


func can_advance_to_next_line():
	if focused and effect_check:
		if effect_check.check_actions_correct():
			print('Well done! Next!')
			return true
		else:
			print('Ohh, its wrong. Keep trying.')
			return false
			
	return false
# Override
func get_class():
	return "CodeLine"
