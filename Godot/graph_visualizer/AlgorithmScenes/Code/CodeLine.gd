class_name CodeLine
extends PanelContainer

# Codelines are used to guide the user. 
# They are focused by an instruction pointer.
# They contain the EffectCheck exported variable
# which are scripts that contain the logic of each code line.
# When code lines are focused, they use the focus() method

export (int) var line_index = 0
export (int) var jump_index = 0
export (bool) var focused = false
export (String) var code_text = 'BFS():'
export (Resource) var effect_check;  # : EffectCheck
export (String) var hint_text = "Press Enter";

var on_focus_effect_triggered : bool = false
var was_completed_correctly: bool = false
var executed_correct_effects_once: bool = false

onready var code_label = $HBoxContainer/CodeText
onready var instruction_pointer : Sprite = $HBoxContainer/InstructionPointer
onready var arrow_hightlight_enter: Node2D = $HBoxContainer/ArrowHightlightEnter

const NOT_SELECTED_COLOR: Color = Color(0.24, 0.24, 0.24, 1.0);
const SELECTED_COLOR: Color = Color(0.6, 0.6, 0.24, 1.0);

const unfocused_style: StyleBox = preload("res://AlgorithmScenes/Code/default_line_code_style.tres")
const focused_style: StyleBox = preload("res://AlgorithmScenes/Code/focused_line_code_style.tres")
const completed_style: StyleBox = preload("res://AlgorithmScenes/Code/completed_line_code_style.tres")


# Change this variable for a given line if it should not play a confirmation audio
export (bool) var plays_confirmation_audio = true 



func _ready():
	code_label.text = code_text
	self.set_process(false)
	if self.effect_check:
		self.effect_check = self.effect_check.new()
		self.effect_check.code_line = self


func _process(_delta: float) -> void:
	if self.effect_check:
		var action_completed = self.effect_check.check_actions_correct()
		if action_completed:
			execute_correct_effects_once()

		# If the player was correct, but then made a mistake
		if self.was_completed_correctly and not action_completed:
			add_stylebox_override("panel", focused_style)
			self.executed_correct_effects_once = false


func execute_correct_effects_once():
	if not self.executed_correct_effects_once:
		add_stylebox_override("panel", completed_style)
		self.was_completed_correctly = true
		self.executed_correct_effects_once = true
		self._show_hightlight_enter()
		if self.effect_check and self.should_play_confirmation_audio():
			NotificationManager.play_confirmation_audio()

func _show_hightlight_enter():
	arrow_hightlight_enter.visible = true

func _hide_hightlight_enter():
	arrow_hightlight_enter.visible = false


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
	_hide_hightlight_enter()
	reset_effect_check()
	# Visual effects, change color and add InsPointer
	if instruction_pointer:
		instruction_pointer.visible = false
	self.was_completed_correctly = false
	self.executed_correct_effects_once = false
	add_stylebox_override("panel", unfocused_style)

# Reset side effect 
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

func get_line_jump() -> int:
	return jump_index


# Whether this code line should play a confirmation audio
# when the action was completed correctly (as stated in CodeLine)
# Override this and make it return false if the line should not 
func should_play_confirmation_audio() -> bool:
	return self.plays_confirmation_audio
