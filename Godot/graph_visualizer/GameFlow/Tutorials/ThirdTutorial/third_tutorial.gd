class_name ThirdTutorial
extends Node2D

const lost_static_noise_material : Material  = preload("res://Assets/custom_shaders/static_noise_lose_material.tres")
# Governs the world for the first tutorial level
var animation_played_once = false

# Used by the if in the CodeBlock. Check res../SecondTutorial/CodeBlockSrc/3_if_u_is_not_a_star.gd
var u_is_not_a_star_correct_answer = false
var u_node: AGraphNode = null
var current_selectable_node: AGraphNode

export (float) var time_to_lose_when_sending_ship_to_sun = 2.0

onready var tutorial_animation_player: AnimationPlayer = $"%AnimationPlayer"
onready var dialogue_displayer: DialogueDisplayer = $DialogueCanvas/DialogueDisplayer
onready var code_block = $HUD/CodeBlock


func _ready():
	tutorial_animation_player.play("OnReady")
	tutorial_animation_player.connect("animation_finished", self, "on_win_animation_finished")

	dialogue_displayer.connect("dialogue_finished", self, "on_dialogue_finished")
	code_block.connect("code_finished", self, "on_win")
	StoredData.world_node = self
	NotificationManager.allow_code_advance = false

func on_win() -> void:
	tutorial_animation_player.play("WinAnimation")
	animation_played_once = true

# Show the click suggestion on each planet, since the dialogue finished
# with the instruction to visit (click on) the planets
func _on_DialogueShower_dialogue_finished():
	# Here we could emphasize the code somehow
	pass

func on_win_audio_play():
	AudioPlayer.play_congratulations_audio()

func on_win_animation_finished(anim_name):
	# Show the dialogue player again, telling the player that they won
	# and that they can continue to the next level. Also congratulate them
	# for saving a little red panda!
	if anim_name == "WinAnimation":
		var new_dialogues_to_show = [
			"Congratulations! Now you know how to follow our instructions",
			"You are almost ready to save galaxies!"
		]
		dialogue_displayer.set_and_start_new_dialogues(new_dialogues_to_show)
		dialogue_displayer.connect("dialogue_finished", self, "on_ending_dialogue_finished")


func on_ending_dialogue_finished() -> void:
	# Go to the next scene
	# Start fade animation
	# once the fade animation finishes, queue_free the tree and go to next scene
	# TODO: Change this by with StoredData.get_random_unfinished_level_path()
	NotificationManager._deferred_goto_scene(StoredData.remaining_levels_to_finish["DFS"], true, self)


const NOISE_SHADER_TRANSITION_DURATION = 5.0


func on_restart_level_pressed():
	NotificationManager._deferred_goto_scene(StoredData.story_mode_scenes["Tutorial2"], true, self)

func get_class() -> String:
	return "Tutorial"

func on_dialogue_finished():
	# Show the last text when skipping or finishing
	dialogue_displayer.has_finished =   true
	tutorial_animation_player.play("FinishDialogue")

func ask_user_if_u_node_is_a_star(input_u_is_not_a_star):
	# Show popup of class UNodeIsNotAStarPopup
	var u_node_is_not_a_star_popup = $HUD/UNodeIsNotAStarPopup
	self.u_is_not_a_star_correct_answer = input_u_is_not_a_star
	if is_instance_valid(u_node_is_not_a_star_popup):
		u_node_is_not_a_star_popup.popup()


func go_back_to_menu():
	AudioPlayer.stop_playing_music() # Whatever the music soundtrack playing, stop it when coming back to the menu
	self.set_name("TempMain")
	call_deferred("queue_free")
	NotificationManager.go_to_scene("res://GameFlow/MainMenu.tscn")


func fade_stack_queue():
	tutorial_animation_player.play("ShowStack")

func show_stack_animation():
	pass

func show_queue_animation():
	pass
