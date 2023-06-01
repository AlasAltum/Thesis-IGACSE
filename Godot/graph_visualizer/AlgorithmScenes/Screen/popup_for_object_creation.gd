class_name PopupForObjectCreation
extends WindowDialog


export (Array) var expected_adt_names
var valid_name_regex = RegEx.new()
onready var name_assign: LineEdit = $NameAssign
onready var error_label: Label = $ErrorNotification
onready var error_anim: AnimationPlayer = $ErrorNotification/AnimationPlayer
onready var explanation_label: Label = $Explanation


func _ready():
	NotificationManager.object_creation_popup = self
	valid_name_regex.compile("^[a-zA-Z_$][a-zA-Z_$0-9]*$")
	error_label.visible = false


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
	# On Popup
	if what == NOTIFICATION_POST_POPUP:
		StoredData.popup_captures_input = true
		$NameAssign.grab_focus()
	# On popup hide
	elif what == NOTIFICATION_POPUP_HIDE:
		StoredData.popup_captures_input = false


func set_next_adt_name(ADT_name: String):
	if explanation_label:
		var msg = "You are about to create a {ADT_name}. Please, specify its name"
		msg = msg.format({"ADT_name": ADT_name})
		explanation_label.text = msg


func _on_EnterButton_pressed():
	_on_NameAssign_text_entered(name_assign.text)


# ADT Creation flow:
# User clicks the slot to create an ADT, this sets the variable
# StoredData.adt_to_be_created, which will be used by the ADT Mediator
func _on_NameAssign_text_entered(variable: String):
	if not _variable_has_valid_name(variable):
		show_not_valid_name_error()
		return
	if not variable in expected_adt_names:
		show_not_expected_variable_name()
		return
	self.visible = false
	StoredData.adt_mediator._on_correct_variable_creation(variable)


func _variable_has_valid_name(variable: String):
	variable = variable.to_lower()
	if valid_name_regex.search(variable):
		return true
	return false


func _play_error_label_animation():
	error_label.visible = true
	error_anim.stop()
	error_anim.queue("message_modulation")
	AudioPlayer.play_error_audio()

func show_not_valid_name_error():
	error_label.text = "Invalid name for variable."
	_play_error_label_animation()


func show_not_expected_variable_name():
	error_label.text = "Name not expected by the algorithm"
	_play_error_label_animation()

