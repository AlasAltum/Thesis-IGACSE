class_name TutorialPlayer
extends AnimationPlayer


var main

func _ready():
	StoredData.animation_player = self
	self.main = get_tree().root.get_node("Main")


func show_code():
	# TODO: Show popup that shows the code
	var code_popup: AcceptDialog = main.get_node("CanvasLayer/TutorialCodePopup")
	if code_popup:
		code_popup.popup()

func show_adt_panel():
	var adt_popup: AcceptDialog = main.get_node("CanvasLayer/TutorialDebugBlockPopup")
	if adt_popup:
		adt_popup.popup()

func show_variables_panel():
	var variables_popup: AcceptDialog = main.get_node("CanvasLayer/TutorialVariablesPopup")
	if variables_popup:
		variables_popup.popup()

func stop_queue_highlight():
	queue("StopQueueHighlight")
