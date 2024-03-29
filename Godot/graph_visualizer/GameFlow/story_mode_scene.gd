class_name FirstStoryModeScene
extends Control

# Store mode scenes allows control over dialogues and manages signals
# They should be used during transition scenes in the story mode

export (NodePath) var animation_node_path
var animation_node : AnimationPlayer


func _ready():
	animation_node = $FadeInOut
	animation_node.play("FadeIn")
	StoredData.world_node = self


func _on_FadeInOut_animation_finished(anim_name):
	if anim_name == "FadeIn":
		var dialogue_shower: DialogueDisplayer = $CanvasLayer/DialogueDisplayer
		if dialogue_shower:
			dialogue_shower.show_first_dialogue()

	if anim_name == "FadeOut":
		go_to_scene("res://AlgorithmScenes/Algorithms/BFSAlgorithmTutorial/BFS_tutorial.tscn")

func go_to_scene(scene_path: String):
	call_deferred("deferred_goto_scene", scene_path)
	self.queue_free()

func deferred_goto_scene(scene_path: String):
	var next_scene = load(scene_path)
	var next_scene_instance = next_scene.instance()
	get_tree().root.add_child(next_scene_instance) 

func _on_DialogueShower_dialogue_finished():
	$Background/Part1Background.ship_movement_speed += 0.2
	$Background/Part1Background.dialogue_finished = true
	if animation_node:
		animation_node.play("FadeOut")
		$LaunchingSound.play()


func get_class() -> String:
	return "StoryModeChapter"
