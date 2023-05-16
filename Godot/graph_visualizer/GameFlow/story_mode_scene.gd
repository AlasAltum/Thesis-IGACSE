extends Control

# Store mode scenes allows control over dialogues and manages signals
# They should be used during transition scenes in the story mode

export (NodePath) var animation_node_path
var animation_node : AnimationPlayer


func _ready():
	var animation_node = null
	if animation_node_path:
		animation_node = get_node(animation_node_path)
		animation_node.play("FadeIn")
		StoredData.world_node = self

func _on_FadeInOut_animation_finished(anim_name):
	if anim_name == "FadeIn":
		var dialogue_shower: DialogueDisplayer = $CanvasLayer/DialogueShower
		if dialogue_shower:
			dialogue_shower.show_first_dialogue()

	if anim_name == "FadeOut":
		var dialogue_shower: DialogueDisplayer = $CanvasLayer/DialogueShower
		if dialogue_shower:
			dialogue_shower.visible = false
			load_next_scene()

func load_next_scene():
	pass
	# load scene res://AlgorithmScenes/Algorithms/BFSAlgorithmTutorial/BFS_tutorial.tscn

func _on_DialogueShower_dialogue_finished():
	$LaunchingSound.play()
	$Background/Part1Background.ship_movement_speed += 0.2
	$Background/Part1Background.dialogue_finished = true
	if animation_node:
		animation_node.play("FadeOut")



	
