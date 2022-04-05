extends WindowDialog
var valid_name_regex = RegEx.new()


func _ready():
	valid_name_regex.compile("^[a-zA-Z_$][a-zA-Z_$0-9]*$")


func variable_has_valid_name(variable: String):
	if valid_name_regex.search(variable):
		return true
	return false


func _on_NameAssign_text_entered(variable: String):
	if variable_has_valid_name(variable):
		self.visible = false
		StoredData._on_correct_variable_creation(variable)
		return true
	else:
		print("Invalid variable name")
	return false
