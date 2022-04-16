extends WindowDialog
class_name AddNodePopup

var incoming_node: AGraphNode
onready var error_label: Label = $ErrorNotification
onready var error_anim: AnimationPlayer = $ErrorNotification/AnimationPlayer


func _ready():
	pass # Replace with function body.


func show_error():
	error_label.visible = true
	error_anim.stop()
	error_anim.play("message_modulation")

func _close_popup():
	self.visible = false

func _on_NameAssign_text_entered(object_name):
	if incoming_node:
		if StoredData.has_variable(object_name):
			StoredData.add_node_to_object(object_name, incoming_node)
		else:
			show_error()
			return
	else:
		# TODO: Show error
		_close_popup()


func _on_EnterButton_pressed():
	_on_NameAssign_text_entered($NameAssign.text)
	_close_popup()
