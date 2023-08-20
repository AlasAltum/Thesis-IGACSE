class_name ThirdTutorial
extends Node2D

const lost_static_noise_material : Material  = preload("res://Assets/custom_shaders/static_noise_lose_material.tres")
# Governs the world for the first tutorial level
var animation_played_once = false

# Used by the if in the CodeBlock. Check res../SecondTutorial/CodeBlockSrc/3_if_u_is_not_a_star.gd
var u_is_not_a_star_correct_answer = false
var u_node: AGraphNode = null
var current_selectable_node: AGraphNode
var allow_edge_selection : bool = false

export (float) var time_between_dialogs = 5.0

onready var tutorial_animation_player: AnimationPlayer = $"%AnimationPlayer"
onready var dialogue_displayer: DialogueDisplayer = $DialogueCanvas/DialogueDisplayer
onready var code_block = $HUD/CodeBlock
onready var dialogue_timer = $DialogueCanvas/DialogueTimer


const __planets_textures_original = [
	preload("res://Assets/textures/planets/level_planets/IceWorld.png"),
	preload("res://Assets/textures/planets/level_planets/LavaWorld.png"),
	preload("res://Assets/textures/planets/level_planets/MuddyTerranWet.png"),
	preload("res://Assets/textures/planets/level_planets/NoAtmosphere2.png"),
	preload("res://Assets/textures/planets/level_planets/NoAtmosphere.png"),
	preload("res://Assets/textures/planets/level_planets/PurpleTerranWet.png"),
	preload("res://Assets/textures/planets/level_planets/RedTerran.png"),
	preload("res://Assets/textures/planets/level_planets/WetPlanet.png")
]

var planets_textures = [
	preload("res://Assets/textures/planets/level_planets/IceWorld.png"),
	preload("res://Assets/textures/planets/level_planets/LavaWorld.png"),
	preload("res://Assets/textures/planets/level_planets/MuddyTerranWet.png"),
	preload("res://Assets/textures/planets/level_planets/NoAtmosphere2.png"),
	preload("res://Assets/textures/planets/level_planets/NoAtmosphere.png"),
	preload("res://Assets/textures/planets/level_planets/PurpleTerranWet.png"),
	preload("res://Assets/textures/planets/level_planets/RedTerran.png"),
	preload("res://Assets/textures/planets/level_planets/WetPlanet.png")
]



func _ready():
	StoredData.world_node = self
	tutorial_animation_player.play("OnReady")
	tutorial_animation_player.connect("animation_finished", self, "on_win_animation_finished")
	reset_planets_textures()
	dialogue_displayer.connect("dialogue_finished", self, "on_dialogue_finished")
	dialogue_displayer.connect("next_dialogue", self, "on_next_dialogue")
	code_block.connect("code_finished", self, "on_win")
	NotificationManager.allow_code_advance = false
	call_deferred("update_names_indexes_of_nodes")
	dialogue_displayer.skip_button.visible = false
	dialogue_displayer.accepts_input = false
	yield(dialogue_timer, "timeout")
	dialogue_displayer.accepts_input = true
	for _node in StoredData.nodes:
		_node.connect("node_add_to_object_request", NotificationManager, "_on_node_add_to_object")
	populate_edges()
	StoredData.world_node = self
	VolumeSlider.visible = true
	
func populate_edges():
	var nodes_and_edges = $Nodes.get_children()
	for _child in nodes_and_edges:
		if _child.get_class() == "GraphEdge":
			StoredData.edges.append(_child)

func update_names_indexes_of_nodes():
	for _node in StoredData.nodes: # _node: AGraphNode
		_node.set_index(_node.index)

func reset_planets_textures():
	self.planets_textures = __planets_textures_original.duplicate(true)

func assign_texture_randomly() -> bool:
	return true

func on_next_dialogue():
	dialogue_displayer.accepts_input = false
	dialogue_displayer.next_button.visible = false
	dialogue_timer.start(time_between_dialogs)
	yield(dialogue_timer, "timeout")
	dialogue_displayer.accepts_input = true
	dialogue_displayer.next_button.visible = true

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
			"TUTORIAL_3_DIALOGUE_6", # "Congratulations! Now you know how to use the variables and add nodes to a Stack",
			"TUTORIAL_3_DIALOGUE_7", # "Save these sad pandas please! THEY NEED YOU!"
		]
		dialogue_displayer.set_and_start_new_dialogues(new_dialogues_to_show)
		dialogue_displayer.connect("dialogue_finished", self, "on_ending_dialogue_finished")
		dialogue_displayer.single_text = false

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
	dialogue_displayer.has_finished = true
	NotificationManager.allow_code_advance = true
	tutorial_animation_player.play("FinishDialogue")
	# Bottom receives a highlight material during the animation
	# Erase that material}
	$HUD/Bottom.material = null

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
