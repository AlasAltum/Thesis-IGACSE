class_name DialogueDisplayer
extends PanelContainer

# This class will show the dialogue text and will allow the player to click through it.
# The player can also press an arrow to go to the next dialogue. A skip button will also be available to skip the cinematic.
# The dialogue will be shown in a box with a background.

onready var dialogue_text: Label = $MarginContainer/VBoxContainer/DialogueText
onready var text_shower: AnimationPlayer = $TextShowerAnimation
onready var skip_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/SkipButton
onready var next_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/NextButton

export (Array) var dialogues_to_show = []
export (int) var current_dialogue_index = 0
export (PackedScene) var next_scene = null


signal dialogue_finished


func _ready():
	pass

# This function will be called when the player clicks on the next dialogue button.
# It will show the next dialogue in the list.
func _on_next_dialogue():
	if current_dialogue_index < dialogues_to_show.size() - 1:
		current_dialogue_index += 1
		dialogue_text.text = ""
		text_shower.stop()
		text_shower.play("ShowText") # Show the text with an animation.
		$DialogueText.text = dialogues_to_show[current_dialogue_index]

	else:
		dialogue_text.text = ""
		_on_dialogue_finished()

func _on_dialogue_finished():
	emit_signal("dialogue_finished")
	self.visible = false
	# Should start next scene



func _on_NextButton_gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		print("owo")

func _on_NextButton_button_up():
	next_button.set_focus_mode(0)

func _on_SkipButton_button_up():
	skip_button.set_focus_mode(0)
