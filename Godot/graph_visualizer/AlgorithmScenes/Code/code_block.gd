extends ScrollContainer
class_name CodeContainer

onready var lines_container = $LinesContainer
var code_lines: Array = []
var curr_line_index : int = 0
var current_line: CodeLine

func _ready():
	for child in lines_container.get_children():
		if child.get_class() == "CodeLine":
			code_lines.append(child)
	current_line = code_lines[0]


func pass_to_next_line() -> void:
	if curr_line_index < code_lines.size() - 1:
		code_lines[curr_line_index].unfocus()
		self.curr_line_index += 1
		code_lines[curr_line_index].focus()
		current_line = code_lines[curr_line_index]
	else:
		print("Finished!")
		# TODO: Add notification msg
	

func _input(event):
	if event.is_action_pressed("code_advance"):
		var can_pass_to_next_line: bool = current_line.can_advance_to_next_line()
		if can_pass_to_next_line:
			pass_to_next_line()

