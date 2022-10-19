class_name PopupForObjectCreation
extends WindowDialog


var valid_name_regex = RegEx.new()
onready var name_assign: LineEdit = $NameAssign
onready var error_label: Label = $ErrorNotification
onready var error_anim: AnimationPlayer = $ErrorNotification/AnimationPlayer
onready var explanation_label: Label = $Explanation


func _ready():
	NotificationManager.object_creation_popup = self
	valid_name_regex.compile("^[a-zA-Z_$][a-zA-Z_$0-9]*$")
	error_label.visible = false

func set_next_adt_name(ADT_name: String):
	if explanation_label:
		var msg = "You are about to create a {ADT_name}, please, specify its name"
		msg = msg.format({"ADT_name": ADT_name})
		explanation_label.text = msg


func variable_has_valid_name(variable: String):
	if valid_name_regex.search(variable):
		return true
	return false

func _on_EnterButton_pressed():
	_on_NameAssign_text_entered(name_assign.text)


# ADT Creation flow:
# When the slot is pressed: StoredData.dragged_adt = draggable_adt by 
# calling the function Slot._on_Area2D_input_event(_viewport, event, _shape_idx)
# Then, when the object is dragged to the variables:
# popup_for_object_creation._on_NameAssign_text_entered(var_name)
# StoredData._on_correct_variable_creation(var_name)
# adt_mediator.add_variable(var_name, StoredData.adt_to_be_created)
func _on_NameAssign_text_entered(variable: String):
	if variable_has_valid_name(variable):
		self.visible = false
		StoredData.adt_mediator._on_correct_variable_creation(variable)

	else:
		show_error()
		return

func show_error():
	error_label.visible = true
	error_anim.stop()
	error_anim.play("message_modulation")


func _on_AnimationPlayer_animation_finished(_anim_name: String) -> void:
	_close_popup()

func _popup():
	self.popup()
	name_assign.grab_focus()


func _close_popup():
	self.hide()
