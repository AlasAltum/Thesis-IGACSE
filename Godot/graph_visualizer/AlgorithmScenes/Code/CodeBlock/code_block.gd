class_name CodeContainer
extends ScrollContainer

export (bool) var allow_advance
onready var lines_container = $MarginContainer/LinesContainer
var code_lines: Array = []
var curr_line_index : int = 0
var current_line: CodeLine
var code_has_finished = false

signal code_finished

func _ready():
	for child in lines_container.get_children():
		if child.get_class() == "CodeLine":
			code_lines.append(child)
	current_line = code_lines[0]


func advance_to_line(next_line: int) -> void:
	if next_line < code_lines.size():
		code_lines[curr_line_index].unfocus()
		self.curr_line_index = next_line
		code_lines[curr_line_index].focus()
		current_line = code_lines[curr_line_index]
	else:
		_on_code_finished()

# It is important that StoredData.popup_captures_input is not activated
# This bool is toggled when a popup wants to use the enter button as a shortcut
func _input(event):
	if (event.is_action_pressed("code_advance") and 
		not StoredData.popup_captures_input and 
		NotificationManager.allow_code_advance and
		not code_has_finished
	):
		if current_line.effect_actions_are_correct():
			advance_to_line(current_line.get_next_line())
		else:
			AudioPlayer.play_not_doable_action_sound()
			current_line.show_error_animation()


func _on_code_finished():
	emit_signal("code_finished")
	code_has_finished = true
	AudioPlayer.play_congratulations_audio()

func activate():
	self.visible = true
	# TODO: maybe we could add an animation instead of just making it visible
