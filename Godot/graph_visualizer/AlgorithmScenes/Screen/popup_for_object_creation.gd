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

func _on_PopUpForObjectCreation_about_to_show():
	StoredData.popup_captures_input = true
	$EnterButton.grab_focus()
	$EnterButton.grab_click_focus()


func _on_PopUpForObjectCreation_popup_hide():
	StoredData.popup_captures_input = false

func _input(event):
	if StoredData.popup_captures_input:
		if event.is_action_pressed("ui_accept"):
			_on_EnterButton_pressed()
		elif event.is_action_pressed("ui_cancel"):
			 _close_popup()

func _popup():
	self.popup()

func _close_popup():
	self.hide()
		
func _notification(what):
	if what == NOTIFICATION_POST_POPUP:
		StoredData.popup_captures_input = true
		$NameAssign.grab_focus()
	elif what == NOTIFICATION_POPUP_HIDE:
		StoredData.popup_captures_input = false


func set_next_adt_name(ADT_name: String):
	if explanation_label:
		var msg = "You are about to create a {ADT_name}. Please, specify its name"
		msg = msg.format({"ADT_name": ADT_name})
		explanation_label.text = msg



func variable_has_valid_name(variable: String):
	if valid_name_regex.search(variable):
		return true
	return false

func _on_EnterButton_pressed():
	_on_NameAssign_text_entered(name_assign.text)


# ADT Creation flow:
# User clicks the slot to create an ADT, this sets the variable
# StoredData.adt_to_be_created, which will be used by the ADT Mediator
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
	error_anim.queue("message_modulation")


func _on_AnimationPlayer_animation_finished(_anim_name: String) -> void:
	_close_popup()
