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
export (float) var time_until_show_hint = 5.0
export (bool) var should_show_hint_on_completed = true

var on_focus_effect_triggered : bool = false
var was_completed_correctly: bool = false
var executed_correct_effects_once: bool = false

onready var code_label = $HBoxContainer/CodeText
onready var instruction_pointer : Sprite = $HBoxContainer/InstructionPointer
onready var arrow_hightlight_enter: Node2D = $HBoxContainer/ArrowHightlightEnter
onready var right_pointer: Sprite = $HBoxContainer/RightPointer
onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var hint_timer: Timer = $HintTimer

const NOT_SELECTED_COLOR: Color = Color(0.24, 0.24, 0.24, 1.0);
const SELECTED_COLOR: Color = Color(0.6, 0.6, 0.24, 1.0);

const unfocused_style: StyleBox = preload("res://AlgorithmScenes/Code/CodeBlock/new_default_line_code_style.tres")
const focused_style: StyleBox = preload("res://AlgorithmScenes/Code/CodeBlock/new_progress_line_code_style.tres")
const completed_style: StyleBox = preload("res://AlgorithmScenes/Code/CodeBlock/new_completed_line_code_style.tres")


# Change this variable for a given line if it should not play a confirmation audio
export (bool) var plays_confirmation_audio = true 

signal instruction_completed


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
			on_correct_instruction_execute_effects_once()

		NotificationManager.set_hint_text(self.hint_text)

		# If the player was correct, but then made a mistake
		if self.was_completed_correctly and not action_completed:
			add_stylebox_override("panel", focused_style)
			self.executed_correct_effects_once = false

func _on_HintTimer_timeout():
	if self.effect_check and self.effect_check.has_method("_show_hint_to_user"):
		self.effect_check._show_hint_to_user()


# Triggered when the instructions from the method EffectCheck.check_actions_correct 
# Have returned true. Should be executed only once.
func on_correct_instruction_execute_effects_once():
	if not self.executed_correct_effects_once:
		effect_check._trigger_on_correct_once()
		add_stylebox_override("panel", completed_style)
		emit_signal("instruction_completed", self)
		self.was_completed_correctly = true
		self.executed_correct_effects_once = true
		self._hide_instruction_pointer()
		self._show_right_instruction_ticket()
		if self.effect_check and self.should_play_confirmation_audio():
			NotificationManager.play_confirmation_audio()
			# Erase instructions to make the player focus on the next line
			NotificationManager.set_hint_text("")

func _show_instruction_pointer():
	if instruction_pointer:
		instruction_pointer.visible = true

func _hide_instruction_pointer():
	if instruction_pointer:
		instruction_pointer.visible = false


func _show_right_instruction_ticket():
	if right_pointer:
		right_pointer.visible =  true
	else:
		breakpoint

func _hide_right_instruction_ticket():
	if right_pointer:
		right_pointer.visible = false

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
		hint_timer.start(time_until_show_hint)
		# Visual effects, change color and add InsPointer
		_show_instruction_pointer()
		add_stylebox_override("panel", focused_style)


func unfocus():
	_on_unfocus()
	if self.effect_check:
		self.set_process(false)


func _on_unfocus():
	focused = false
	# RESET variables
	_hide_right_instruction_ticket()
	reset_effect_check()
	# Visual effects, change color and add Instruction Pointer
	if instruction_pointer:
		instruction_pointer.visible = false
	self.was_completed_correctly = false
	self.executed_correct_effects_once = false
	add_stylebox_override("panel", unfocused_style)

func deactivate_hint_timer():
	hint_timer.stop()

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


# When trying to go forward with a wrong instruction
func show_error_animation():
	anim_player.play("OnError")
