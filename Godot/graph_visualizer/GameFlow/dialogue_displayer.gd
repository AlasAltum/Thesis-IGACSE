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

onready var dialogue_audio: AudioStreamPlayer = $DialogueAudio
onready var sound_timer: Timer = $DialogueAudioTimer

export (float) var sound_repetition_speed = 0.1
export (float) var original_dialogue_speed = 0.5
export (Array, String, MULTILINE) var dialogues_to_show = []
export (int) var current_dialogue_index = -1
# This script should contain all the command methods that are going to be called
# from this dialogue
export (Resource) var command_methods_script;  # : CommandMethod
export (bool) var should_close_on_finish = true

var has_finished : bool = false
var command_methods: Array = [] # Array<String>
var executed_command_methods = []
var rand_generator : RandomNumberGenerator
signal dialogue_finished


func _ready():
	rand_generator = RandomNumberGenerator.new()
	next_button.connect("pressed", self, "_on_NextButton_pressed")
	skip_button.connect("pressed", self, "_on_SkipButton_pressed")
	text_shower_animation.connect("animation_finished", self, "on_dialogue_displayed_to_the_end")
	sound_timer.connect("timeout", self, "_play_dialogue_sound")
	text_shower_animation.playback_speed = original_dialogue_speed
	dialogue_text.text = ""

	# We identify previously the command methods so we can execute them
	# if the dialogue is skipped.
	command_methods = _get_command_methods_in_conversation()
	
	# Create instance of command script
	if command_methods_script:
		command_methods_script = command_methods_script.new()
		command_methods_script.parent_dialogue = self

	show_first_dialogue()
	_play_dialogue_sound()


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
	# Check if dialogue finished
	if current_dialogue_index >= dialogues_to_show.size() - 1:
		_on_dialogue_finished()
		return

	_update_dialogue_and_text()
	execute_command_methods_in_text(dialogues_to_show[current_dialogue_index])


func _update_dialogue_and_text():
	# UNSAFE: Assume we already checked the current_dialogue_index
	current_dialogue_index += 1
	dialogue_text.text = _get_clean_text_from_dialogue(dialogues_to_show[current_dialogue_index])
	text_shower_animation.stop()
	# Start sound timer
	sound_timer.start()
	sound_timer.wait_time = sound_repetition_speed

	text_shower_animation.play("ShowText") # Show the text with an animation.

func _on_dialogue_finished():
	# Do not allow this function to be repeated
	if has_finished:
		return
	if should_close_on_finish:
		dialogue_text.text = ""
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
func execute_command_methods_in_text(input_text: String) -> void:
	if _has_command_method(input_text):
		var command_methods_in_text = _get_command_methods_in_text(input_text)
		for _command_method in command_methods_in_text:
			_execute_single_command_method(_command_method)


# This function will be called when the animation of the text being displayed
# is finished. It will set the playback speed of the animation to the original
# speed. In case the player pressed a button to accelerate the dialogue	
func on_dialogue_displayed_to_the_end(_animation_name):
	text_shower_animation.playback_speed = original_dialogue_speed
	if _animation_name == "ShowText":
		sound_timer.stop()

func _on_NextButton_button_up():
	next_button.set_focus_mode(0)

func _on_NextButton_pressed():
	_on_next_dialogue()
	confirm_action_audio.play()


func _on_SkipButton_button_up():
	skip_button.set_focus_mode(0)

func _on_SkipButton_pressed():
	_activate_remaining_command_methods()
	_on_dialogue_finished()
	confirm_action_audio.play()

# This function will set the dialogues to show and show the first dialogue.
# It will also reset the current dialogue index.
# It should be used during tutorials when ending a tutorial.
func set_and_start_new_dialogues(new_dialogues: Array):
	dialogues_to_show = new_dialogues
	current_dialogue_index = -1
	# A reset must be performed
	self.visible = true
	self.has_finished = false
	show_first_dialogue()


func _get_command_methods_in_conversation():
	# A conversation may have multiple dialogues or texts
	for dialogue in dialogues_to_show:
		if _has_command_method(dialogue):  # { "something" }
			# Get an array of strings with all command methods in the text
			var command_methods_in_text: Array = _get_command_methods_in_text(dialogue)
			command_methods.append_array(command_methods_in_text)
	return command_methods


func _get_command_methods_in_text(input_text: String):
	var temp_command_methods = []
	var is_inside_command_method = false
	var current_command_method = ""

	# mark beginning or end, and start or stop adding characters to current command method
	# basically, add everything between the curly braces {  }
	for character in input_text:
		if character == "{":
			is_inside_command_method = true
			continue
		elif character == "}":
			is_inside_command_method = false
			temp_command_methods.append(current_command_method)
			current_command_method = ""
			continue

		if is_inside_command_method:
			current_command_method += character

	return temp_command_methods

func _activate_remaining_command_methods():
	# Assume we already have populated the self.command_methods array
	for curr_command_method in self.command_methods:
		if not curr_command_method in self.executed_command_methods:
			_execute_single_command_method(curr_command_method)

func _execute_single_command_method(command_method_name: String):
	command_methods_script.execute_command(command_method_name)
	self.executed_command_methods.append(command_method_name)


func set_dialogue_by_index(index: int):
	if index < len(self.dialogues_to_show):
		var raw_text = dialogues_to_show[len(dialogues_to_show) - 1]
		dialogue_text.text = _get_clean_text_from_dialogue(raw_text)

func _play_dialogue_sound():
	sound_timer.wait_time = sound_repetition_speed + rand_generator.randfn(0, 0.01)
	dialogue_audio.play()
