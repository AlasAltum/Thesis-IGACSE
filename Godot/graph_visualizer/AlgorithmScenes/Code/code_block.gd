class_name CodeContainer
extends ScrollContainer

export (bool) var allow_advance
onready var lines_container = $LinesContainer
var code_lines: Array = []
var curr_line_index : int = 0
var current_line: CodeLine


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
		NotificationManager.allow_code_advance
	):
		if current_line.effect_actions_are_correct():
			advance_to_line(current_line.get_next_line())
		else:
			# TODO: Warn the player that the code has not been completed yet
			AudioPlayer.play_not_doable_action_sound()


func _on_code_finished():
	pass

func activate():
	NotificationManager.allow_code_advance = false
	self.visible = true
	# TODO: maybe we could add an animation instead of just making it visible
