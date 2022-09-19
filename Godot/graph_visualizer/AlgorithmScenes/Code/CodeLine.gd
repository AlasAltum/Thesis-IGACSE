class_name CodeLine
extends PanelContainer

# Codelines are used to guide the user. 
# They are focused by an instruction pointer.
# They contain the effect check exported variable
# Which are scripts that contain the logic of each code line
# When code lines are focused, they use the focus() method

export (int) var line_index = 0
export (int) var jump_index = 0
export (bool) var focused = false
export (String) var code_text = 'BFS():'
export (Resource) var effect_check;
export (String) var hint_text = "Press Enter";
#var effect_check2 : EffectCheck
var on_focus_effect_triggered : bool = false

onready var code_label = $MarginContainer/HBoxContainer/CodeText
onready var instruction_pointer : Sprite = $MarginContainer/HBoxContainer/InstructionPointer

const NOT_SELECTED_COLOR: Color = Color(0.24, 0.24, 0.24, 1.0);
const SELECTED_COLOR: Color = Color(0.6, 0.6, 0.24, 1.0);

const unfocused_style: StyleBox = preload("res://AlgorithmScenes/Code/default_line_code_style.tres")
const focused_style: StyleBox = preload("res://AlgorithmScenes/Code/focused_line_code_style.tres")
const completed_style: StyleBox = preload("res://AlgorithmScenes/Code/completed_line_code_style.tres")

func _ready():
	code_label.text = code_text
	self.set_process(false)
	if self.effect_check:
		self.effect_check = self.effect_check.new()
		self.effect_check.code_line = self

func _process(delta: float) -> void:
	if self.effect_check:
		var action_completed = self.effect_check.check_actions_correct()
		if action_completed:
			add_stylebox_override("panel", completed_style)

func focus():
	_on_focused()
	if self.effect_check:
		self.set_process(true)


func _on_focused():
	focused = true
	NotificationManager.set_hint_text(self.hint_text)
	if self.effect_check and not self.on_focus_effect_triggered:
		self.effect_check.effect_check_on_focused()
		self.on_focus_effect_triggered = true
		# Visual effects, change color and add InsPointer
		if instruction_pointer:
			instruction_pointer.visible = true
		add_stylebox_override("panel", focused_style)


func unfocus():
	_on_unfocus()
	if self.effect_check:
		self.set_process(false)

func _on_unfocus():
	focused = false
	# RESET variables
	reset_effect_check()
	# Visual effects, change color and add InsPointer
	if instruction_pointer:
		instruction_pointer.visible = false

	add_stylebox_override("panel", unfocused_style)


# Resett side effect 
func reset_effect_check():
	self.on_focus_effect_triggered = false
	if self.effect_check:
		self.effect_check.reset()

func effect_actions_are_correct():
	if effect_check:
		return effect_check.check_actions_correct()
	
# Given the EffectCheck for this code line,
# Get the next line that should be included
func get_next_line() -> int:
	if focused and effect_check:
		# The next line is given by the effect of the line
		# Since jumps may happen
		return effect_check.get_next_line()
	else:
		print("Error with line N° " + str(line_index))

	return line_index


func get_class():
	return "CodeLine"

## fors, functions, ifs and whiles perform instruction jumps
## this jumps are personalized in the effect check script for each line
#func should_jump_to_line() -> bool:
#	return effect_check.should_jump_to_line()

func get_line_jump() -> int:
	return jump_index
