class_name TutorialPlayer
extends AnimationPlayer


var main
var has_played_stop_queue_hightlight_once = false 

func _ready():
	StoredData.animation_player = self
	self.main = get_tree().root.get_node("Main")
	play("HighlightInstructions")


func show_code():
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
		self.queue("ShowVariablesPanel")
		variables_popup.popup()


func show_current_variable_popup():
	queue("ShowCurrentVariable")

# The player may not understand what the current variable is
# So we will display a popup explaining what the current variable is
# func show_current_variable():

func play_show_data_structures_panel():
	self.queue("ShowDataStructuresPanel")

func stop_queue_highlight_once():
	if not has_played_stop_queue_hightlight_once:
		queue("StopQueueHighlight")
		has_played_stop_queue_hightlight_once = true
