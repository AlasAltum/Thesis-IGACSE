class_name FirstTutorial
extends Node2D

# Governs the world for the first tutorial level


onready var starting_node: AGraphNode = $ColorRect/StartingNode
onready var planet1: AGraphNode = $ColorRect/Planet1
onready var planet2: AGraphNode = $ColorRect/Planet2



func _ready():
	StoredData.selectable_nodes.append_array([planet1.index, planet2.index])
	planet1.connect("node_selected", self, "send_ship_to_node")
	planet2.connect("node_selected", self, "send_ship_to_node")
	
	
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
	if planet1.selected and planet2.selected:
		$AnimationPlayer.play("WinAnimation")


# Show the click suggestion on each planet, since the dialogue finished
# with the instruction to visit (click on) the planets
func _on_DialogueShower_dialogue_finished():
	planet1.show_animation_of_clicking_mouse()
	planet2.show_animation_of_clicking_mouse()


func on_win_audio_play():
	AudioPlayer.play_congratulations_audio()
