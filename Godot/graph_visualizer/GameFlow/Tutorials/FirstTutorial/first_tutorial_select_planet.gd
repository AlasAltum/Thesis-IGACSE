class_name FirstTutorial
extends Node2D

# Governs the world for the first tutorial level
var animation_played_once = false


onready var starting_node: AGraphNode = $ColorRect/StartingNode
onready var planet1: AGraphNode = $ColorRect/Planet1
onready var planet2: AGraphNode = $ColorRect/Planet2
onready var tutorial_animation_player: AnimationPlayer = $AnimationPlayer
onready var dialogue_displayer: DialogueDisplayer = $DialogueCanvas/DialogueDisplayer


func _ready():
	StoredData.selectable_nodes_indexes.append_array([planet1.index, planet2.index])
	planet1.connect("node_selected", self, "send_ship_to_node")
	planet2.connect("node_selected", self, "send_ship_to_node")
	tutorial_animation_player.play("OnReady")
	tutorial_animation_player.connect("animation_finished", self, "on_animation_finished")
	planet1.animation_player.connect("animation_finished", self, "on_ship_arrived_to_planet")
	planet2.animation_player.connect("animation_finished", self, "on_ship_arrived_to_planet")
	dialogue_displayer.connect("dialogue_finished", self, "_on_DialogueShower_dialogue_finished")


func send_ship_to_node(end_planet: AGraphNode):
	# Since there is always only one edge, this should work fine
	var edge #  = $ColorRect/Edge1S:
	if end_planet == planet1:
		edge = $ColorRect/Edge1S
	elif end_planet == planet2:
		edge = $ColorRect/Edge2S
	if edge:
		edge.send_ship_from_nodeA_to_nodeB(starting_node, end_planet)
	# Check if both planets have been pressed. If so,
	# win and go to the next level after an animation
	# if planet1.selected and planet2.selected:
	# Wait until the ship arrives at planet 1 and 2 to show the win animation		

func on_ship_arrived_to_planet(animation_name):
	if animation_name == "NodeBeingSelected":
		if planet1.selected and planet2.selected and not animation_played_once:	
			on_win()

func on_win() -> void:
	tutorial_animation_player.play("WinAnimation")
	animation_played_once = true

# Show the click suggestion on each planet, since the dialogue finished
# with the instruction to visit (click on) the planets
func _on_DialogueShower_dialogue_finished():
	planet1.show_animation_of_clicking_mouse()
	planet2.show_animation_of_clicking_mouse()

func on_win_audio_play():
	AudioPlayer.play_congratulations_audio()

func on_animation_finished(anim_name):
	if anim_name == "WinAnimation":
		on_win_animation_finished(anim_name)
	elif anim_name == "FadeIn":
		on_end_animation_finished(anim_name)

func on_win_animation_finished(_anim_name):
	# Show the dialogue player again, telling the player that they won
	# and that they can continue to the next level. Also congratulate them
	# for saving a little red panda!
	var new_dialogues_to_show = [
		"Congratulations! You saved a little red panda!",
		"You are ready to go to the next level and rescue more pandas!"
	]
	dialogue_displayer.set_and_start_new_dialogues(new_dialogues_to_show)
	# Set the next level to be the second tutorial
	dialogue_displayer.connect("dialogue_finished", self, "on_ending_dialogue_finished")

func on_end_animation_finished(_anim_name):
	pass

func get_class() -> String:
	return "Tutorial"

func on_ending_dialogue_finished() -> void:
	# Go to the next scene
	# Start fade animation
	# once the fade animation finishes, queue_free the tree and go to next scene
	NotificationManager._deferred_goto_scene(StoredData.story_mode_scenes["Tutorial2"], true, self)

