class_name SecondTutorial
extends Node2D

const lost_static_noise_material : Material  = preload("res://Assets/custom_shaders/static_noise_lose_material.tres")
# Governs the world for the first tutorial level
var animation_played_once = false

# Used by the if in the CodeBlock. Check res../SecondTutorial/CodeBlockSrc/3_if_u_is_not_a_star.gd
var u_is_not_a_star_correct_answer = false
var u_node: AGraphNode = null
var current_selectable_node: AGraphNode

export (float) var time_to_lose_when_sending_ship_to_sun = 2.0

onready var starting_node: AGraphNode = $Nodes/StartingNode1
onready var nodes_background: ColorRect = $Nodes
onready var star: AGraphNode = $Nodes/Star
onready var planet2: AGraphNode = $Nodes/Planet2
onready var planet3: AGraphNode = $Nodes/Planet3
onready var tutorial_animation_player: AnimationPlayer = $AnimationPlayer
onready var dialogue_displayer: DialogueDisplayer = $DialogueCanvas/DialogueDisplayer
onready var timer_to_lose_when_sending_ship_to_sun: Timer = $TimerToLose
onready var code_block = $HUD/CodeBlock
onready var lost_scene = $HUD/OnGameLostPopup
onready var noise_audio_player : AudioStreamPlayer = $NoiseAudioPlayer  # When losing


func _ready():
#	StoredData.selectable_nodes_indexes.append_array([star.index, planet2.index])
	star.connect("node_selected", self, "send_ship_to_node")
	planet2.connect("node_selected", self, "send_ship_to_node")
	planet3.connect("node_selected", self, "send_ship_to_node")
	tutorial_animation_player.play("OnReady")
	tutorial_animation_player.connect("animation_finished", self, "on_win_animation_finished")

	dialogue_displayer.connect("dialogue_finished", self, "on_dialogue_finished")
	code_block.connect("code_finished", self, "on_win")
	StoredData.world_node = self
	NotificationManager.allow_code_advance = false
	timer_to_lose_when_sending_ship_to_sun.connect("timeout", self, "on_ship_arrived_to_sun")
	var sun_movement_anim = $Nodes/Star/Sprite/SpriteTexture/SunMovement
	sun_movement_anim.play("PlanetMovement")
	VolumeSlider.set_menu_visibility(true)
	StoredData.selectable_nodes_indexes = []

func send_ship_to_node(end_planet: AGraphNode):
	# Since there is always only one edge, this should work fine
	var edge #  = $Nodes/Edge1S:
	match end_planet:
		star:
			edge = $Nodes/Edge1Star
		planet2:
			edge = $Nodes/Edge2S
		planet3:
			edge = $Nodes/Edge13

	edge.send_ship_from_nodeA_to_nodeB(starting_node, end_planet)
	if edge and end_planet == star:
		# await for 1.5 seconds and lose
		timer_to_lose_when_sending_ship_to_sun.start(time_to_lose_when_sending_ship_to_sun)


func on_win() -> void:
	tutorial_animation_player.play("WinAnimation")
	animation_played_once = true

func on_win_audio_play():
	AudioPlayer.play_congratulations_audio()

func on_win_animation_finished(anim_name):
	# Show the dialogue player again, telling the player that they won
	# and that they can continue to the next level. Also congratulate them
	# for saving a little red panda!
	if anim_name == "WinAnimation":
		var new_dialogues_to_show = [
			"TUTORIAL_2_DIALOGUE_5", #"Congratulations! Now you know how to follow our instructions",
			"TUTORIAL_2_DIALOGUE_6", #You are almost ready to save galaxies!"
		]
		dialogue_displayer.set_and_start_new_dialogues(new_dialogues_to_show)
		dialogue_displayer.connect("dialogue_finished", self, "on_ending_dialogue_finished")


func on_ending_dialogue_finished() -> void:
	# Go to the next scene
	# Start fade animation
	# once the fade animation finishes, queue_free the tree and go to next scene
	# TODO: Change this by with StoredData.get_random_unfinished_level_path()
	StoredData.reset_data()
	NotificationManager._deferred_goto_scene(StoredData.story_mode_scenes["Tutorial3"], true, self)

func on_ship_arrived_to_sun():
	on_lose()


const NOISE_SHADER_TRANSITION_DURATION = 5.0

func on_lose() -> void:
	# Show a popup
	lost_scene.popup()
	lost_scene.connect("restart_level", self, "on_restart_level_pressed")
	tutorial_animation_player.play("LoseAnimation")
	nodes_background.material = lost_static_noise_material as ShaderMaterial
	nodes_background.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
	var tween = $Nodes/Tween

#	static_noise_shader
	tween.interpolate_method(
		nodes_background.material,
		"set_shader_param",
		0.0,
		40.0,
		NOISE_SHADER_TRANSITION_DURATION
	)
	tween.start()
	noise_audio_player.play()

	tween.interpolate_method(
		noise_audio_player,
		"volume_db",
		-30.0,
		-20.0,
		NOISE_SHADER_TRANSITION_DURATION
	)
	tween.start()

func on_restart_level_pressed():
	NotificationManager._deferred_goto_scene(StoredData.story_mode_scenes["Tutorial2"], true, self)

func get_class() -> String:
	return "Tutorial"

func on_dialogue_finished():
	# Show the last text when skipping or finishing
	dialogue_displayer.set_dialogue_by_index(len(dialogue_displayer.dialogues_to_show) - 1)
	dialogue_displayer.has_finished = true

func ask_user_if_u_node_is_a_star(input_u_is_not_a_star):
	# Show popup of class UNodeIsNotAStarPopup
	var u_node_is_not_a_star_popup = $HUD/UNodeIsNotAStarPopup
	self.u_is_not_a_star_correct_answer = input_u_is_not_a_star
	if is_instance_valid(u_node_is_not_a_star_popup):
		u_node_is_not_a_star_popup.popup()


func assign_texture_randomly() -> bool:
	return false


# Show the click suggestion on each planet, since the dialogue finished
# with the instruction to visit (click on) the planets
func _on_DialogueShower_dialogue_finished():
	# Here we could emphasize the code somehow
	$Nodes/Star/Sprite/SpriteTexture/SunMovement.play("PlanetMovement")

func send_ship_to_the_sun():
	send_ship_to_node(star)

func go_back_to_menu():
	AudioPlayer.stop_playing_music() # Whatever the music soundtrack playing, stop it when coming back to the menu
	self.set_name("TempMain")
	call_deferred("queue_free")
	NotificationManager.go_to_scene("res://GameFlow/MainMenu.tscn")
