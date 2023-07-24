class_name SecondTutorial
extends Node2D

# Governs the world for the first tutorial level
var animation_played_once = false
const lost_popup_scene = preload("res://AlgorithmScenes/Screen/LosePopup.tscn")
var lost_scene


export (float) var time_to_lose_when_sending_ship_to_sun = 2.0

onready var starting_node: AGraphNode = $Nodes/StartingNode1
onready var star: AGraphNode = $Nodes/Star
onready var planet2: AGraphNode = $Nodes/Planet2
onready var planet3: AGraphNode = $Nodes/Planet3
onready var tutorial_animation_player: AnimationPlayer = $AnimationPlayer
onready var dialogue_displayer: DialogueDisplayer = $DialogueCanvas/DialogueDisplayer
onready var timer_to_lose_when_sending_ship_to_sun: Timer = $TimerToLose
onready var code_block = $HUD/CodeBlock


func _ready():
#	StoredData.selectable_nodes_indexes.append_array([star.index, planet2.index])
	star.connect("node_selected", self, "send_ship_to_node")
	planet2.connect("node_selected", self, "send_ship_to_node")
	tutorial_animation_player.play("OnReady")
	tutorial_animation_player.connect("animation_finished", self, "on_win_animation_finished")
#	star.animation_player.connect("animation_finished", self, "on_ship_arrived_to_sun")
	planet2.animation_player.connect("animation_finished", self, "on_ship_arrived_to_planet")
	dialogue_displayer.connect("dialogue_finished", self, "on_dialogue_finished")
	code_block.connect("code_finished", self, "on_win")
	StoredData.world_node = self
	NotificationManager.allow_code_advance = false
	timer_to_lose_when_sending_ship_to_sun.connect("timeout", self, "on_ship_arrived_to_sun")
	var sun_movement_anim = $Nodes/Star/Sprite/SpriteTexture/SunMovement
	sun_movement_anim.play("PlanetMovement")

func send_ship_to_node(end_planet: AGraphNode):
	# Since there is always only one edge, this should work fine
	var edge #  = $Nodes/Edge1S:
	if end_planet == star:
		edge = $Nodes/Edge1S
	elif end_planet == planet2:
		edge = $Nodes/Edge2S
	if edge and end_planet == star:
		edge.send_ship_from_nodeA_to_nodeB( starting_node, end_planet)
		# await for 1.5 seconds and lose
		timer_to_lose_when_sending_ship_to_sun.start(time_to_lose_when_sending_ship_to_sun)

	else:
		edge.send_ship_from_nodeA_to_nodeB(starting_node, end_planet)
	# Check if both planets have been pressed. If so,
	# win and go to the next level after an animation
	# if planet1.selected and planet2.selected:
	# Wait until the ship arrives at planet 1 and 2 to show the win animation

func on_ship_arrived_to_planet(animation_name):
	if animation_name == "NodeBeingSelected":
		pass

func on_win() -> void:
	tutorial_animation_player.play("WinAnimation")
	animation_played_once = true

# Show the click suggestion on each planet, since the dialogue finished
# with the instruction to visit (click on) the planets
func _on_DialogueShower_dialogue_finished():
	# Here we could emphasize the code somehow
	$Nodes/Star/Sprite/SpriteTexture/SunMovement.play("PlanetMovement")


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

func on_ship_arrived_to_sun():
	# TODO: make the player lose, open a popup and reset
	on_lose()

func on_lose() -> void:
	# Show a popup
	lost_scene = lost_popup_scene.instance()
	add_child(lost_scene)
	lost_scene.popup()
	lost_scene.connect("restart_level", self, "on_restart_level_pressed")

func on_restart_level_pressed():
	NotificationManager._deferred_goto_scene(StoredData.story_mode_scenes["Tutorial2"], true, self)

func get_class() -> String:
	return "Tutorial"

func on_dialogue_finished():
	# Show the last text when skipping or finishing
	dialogue_displayer.set_dialogue_by_index(len(dialogue_displayer.dialogues_to_show) - 1)
	dialogue_displayer.has_finished = true
