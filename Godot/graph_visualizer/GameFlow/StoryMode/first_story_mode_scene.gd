class_name StoryModeScene
extends Control

# Store mode scenes allows control over dialogues and manages signals
# They should be used during transition scenes in the story mode
export (PackedScene) var on_fade_out_next_scene
export (NodePath) var animation_node_path
var animation_node : AnimationPlayer


func _ready():
	animation_node = $FadeInOut
	animation_node.play("FadeIn")
	StoredData.world_node = self 
	$DialogueCanvas/DialogueDisplayer.connect("dialogue_finished", self, "_on_DialogueShower_dialogue_finished")
	VolumeSlider.set_menu_visibility(true)

func _on_FadeInOut_animation_finished(anim_name):
	if anim_name == "FadeIn":
		var dialogue_shower: DialogueDisplayer = $CanvasLayer/DialogueDisplayer
		if dialogue_shower:
			dialogue_shower.show_first_dialogue()

	if anim_name == "FadeOut":
		go_to_scene(on_fade_out_next_scene.get_path())

func go_to_scene(scene_path: String):
	call_deferred("deferred_goto_scene", scene_path)

func deferred_goto_scene(scene_path: String):
	self.queue_free()
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

func assign_texture_randomly() -> bool:
	return false

