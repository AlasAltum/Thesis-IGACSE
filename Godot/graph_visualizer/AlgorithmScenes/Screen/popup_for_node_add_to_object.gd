extends WindowDialog
class_name AddNodePopup
# Popup that appears when we want to add a node to a ADT
# By making right click on a node and selecting to add to an ADT

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
			StoredData.add_node_to_adt(object_name, incoming_node)

		else: # Case a node was tried to be added to a non-existing object
			show_error()
			return


func _on_EnterButton_pressed():
	_on_NameAssign_text_entered($NameAssign.text)
	_close_popup()
