class_name DialogueDisplayer
extends PanelContainer

# This class will show the dialogue text and will allow the player to click through it.
# The player can also press an arrow to go to the next dialogue. A skip button will also be available to skip the cinematic.
# The dialogue will be shown in a box with a background.
# Note: The dialogues can have special comamnds. These commands trigger methods
# from the script that this DialogueContains. The script contains instructions
# such as the methods that can be executed


onready var dialogue_text: Label = $MarginContainer/VBoxContainer/DialogueText
onready var text_shower_animation: AnimationPlayer = $TextShowerAnimation
onready var skip_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/SkipButton
onready var next_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/NextButton
onready var confirm_action_audio: AudioStreamPlayer = $ConfirmActionAudio

export (float) var original_dialogue_speed = 0.5
export (Array, String, MULTILINE) var dialogues_to_show = []
export (int) var current_dialogue_index = -1
export (PackedScene) var next_scene = null
export (Resource) var command_methods_script;  # : CommandMethod
export (bool) var should_transfer_to_next_scene = true

var has_finished : bool = false

signal dialogue_finished


func _ready():
	if next_scene == null:
		printerr("Dialogue Displayer: next scene is null!")

	next_button.connect("pressed", self, "_on_NextButton_pressed")
	skip_button.connect("pressed", self, "_on_SkipButton_pressed")
	text_shower_animation.connect("animation_finished", self, "on_dialogue_displayed_to_the_end")
	text_shower_animation.playback_speed = original_dialogue_speed
	dialogue_text.text = ""
	# Create instance of command script
	if command_methods_script:
		command_methods_script = command_methods_script.new()
		command_methods_script.parent_dialogue = self
	show_first_dialogue()

func show_first_dialogue():
	# Show an animation of the dialogue player being displayed
	# then show the first dialogue
	_on_next_dialogue()

func _input(event):
	if not has_finished and event is InputEventKey and event.is_action_pressed("NextDialogue"):
		# When the player presses for next dialogue we want to show the text
		# immediately. So we will stop the animation and set the playback speed
		# to a very high value, simulating that the animation is finished.
		if text_shower_animation.current_animation == "ShowText":
			text_shower_animation.playback_speed = 100

		else:
			_on_next_dialogue()

# This function will be called when the player clicks on the next dialogue button.
# It will show the next dialogue in the list.
func _on_next_dialogue():
	if current_dialogue_index >= dialogues_to_show.size() - 1:
		dialogue_text.text = ""
		_on_dialogue_finished()
		return

	current_dialogue_index += 1
	var new_text = dialogues_to_show[current_dialogue_index]
	dialogue_text.text = _get_clean_text_from_dialogue(new_text)
	text_shower_animation.stop()
	text_shower_animation.play("ShowText") # Show the text with an animation.
	if _has_command_method(new_text):
		execute_command_methods_in_dialogue(new_text)


func _on_dialogue_finished():
	# Do not allow this function to be repeated
	if has_finished:
		return

	self.visible = false
	has_finished = true
	emit_signal("dialogue_finished")
	# Here we could start next scene
	# But it is better that each world node knows when to end
	# They can use the dialogue_finished signal anyway

# Clean text is the text that does not contain any command methods.
# command methods are represented using curly braces {command_method}
# This function will return the text without the command methods.
func _get_clean_text_from_dialogue(input_text: String) -> String:
	var clean_text = input_text
	# Remove all command methods from text, removing all text between curly braces { }
	while clean_text.find("{") != -1 and clean_text.find("}") != -1:
		var start_index = clean_text.find("{")
		var end_index = clean_text.find("}")
		clean_text = clean_text.replace(clean_text.substr(start_index, end_index - start_index + 1), "")

	return clean_text


# This function will return true if the input text contains a command method
# and false otherwise
func _has_command_method(input_text: String) -> bool:
	if input_text.find("{") != -1 and input_text.find("}") != -1:
		return true
	return false

# This function will execute the command methods in the input text.
func execute_command_methods_in_dialogue(input_text: String) -> void:
	# Get every command method in the input text by getting the text between the curly braces
	var command_methods = []
	var current_command_method = ""
	var is_inside_command_method = false

	for character in input_text:
		# mark beginning or end, and start or stop adding characters to current command method
		if character == "{":
			is_inside_command_method = true
		elif character == "}":
			is_inside_command_method = false
			command_methods.append(current_command_method)
			current_command_method = ""
		# add character to current command method if we are inside a command method {x___ 
		# and haven't reached yet a closing curly brace
		elif is_inside_command_method:
			current_command_method += character

	# Execute all command methods in text
	for command_method in command_methods:
		command_methods_script.call(command_method)


# This function will be called when the animation of the text being displayed
# is finished. It will set the playback speed of the animation to the original
# speed. In case the player pressed a button to accelerate the dialogue	
func on_dialogue_displayed_to_the_end(_animation_name):
	text_shower_animation.playback_speed = original_dialogue_speed

func _on_NextButton_button_up():
	next_button.set_focus_mode(0)

func _on_NextButton_pressed():
	_on_next_dialogue()
	confirm_action_audio.play()


func _on_SkipButton_button_up():
	skip_button.set_focus_mode(0)

func _on_SkipButton_pressed():
	_on_dialogue_finished()
	confirm_action_audio.play()

# This function will set the dialogues to show and show the first dialogue.
# It will also reset the current dialogue index.
# It should be used during tutorials when ending a tutorial.
func set_and_start_new_dialogues(new_dialogues: Array):
	dialogues_to_show = new_dialogues
	current_dialogue_index = -1
	# a reset must be performed
	self.visible = true
	self.has_finished = false
	show_first_dialogue()

