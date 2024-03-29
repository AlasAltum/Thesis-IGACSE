extends EffectCheck

# Press Enter
var has_enter_been_pressed : bool = false

func _ready():
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("code_advance") and NotificationManager.allow_code_advance:
		has_enter_been_pressed = true

func _trigger_on_next_line_side_effect():
	# In this case, the world is the second tutorial
	var tutorial_node = StoredData.world_node
	if tutorial_node:
		tutorial_node.dialogue_displayer.visible = false


func check_actions_correct() -> bool:
	if Input.is_action_just_pressed("code_advance"):
		if NotificationManager.allow_code_advance:
			has_enter_been_pressed = true
	return has_enter_been_pressed

