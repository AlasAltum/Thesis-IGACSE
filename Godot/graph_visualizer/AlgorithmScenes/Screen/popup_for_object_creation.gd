extends WindowDialog
var valid_name_regex = RegEx.new()
onready var name_assign: LineEdit = $NameAssign
onready var error_label: Label = $ErrorNotification
onready var error_anim: AnimationPlayer = $ErrorNotification/AnimationPlayer


func _ready():
	valid_name_regex.compile("^[a-zA-Z_$][a-zA-Z_$0-9]*$")


func variable_has_valid_name(variable: String):
	if valid_name_regex.search(variable):
		return true
	return false


func _on_EnterButton_pressed():
	_on_NameAssign_text_entered(name_assign.text)


func _on_NameAssign_text_entered(variable: String):
	if variable_has_valid_name(variable):
		self.visible = false
		StoredData._on_correct_variable_creation(variable)
		return true
	else:
		error_label.visible = true
		error_anim.stop()
		error_anim.play("message_modulation")

	return false


