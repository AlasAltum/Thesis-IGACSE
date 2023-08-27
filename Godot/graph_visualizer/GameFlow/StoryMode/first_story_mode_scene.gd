class_name StoryModeScene
extends Control

# Store mode scenes allows control over dialogues and manages signals
# They should be used during transition scenes in the story mode
export (PackedScene) var on_fade_out_next_scene
export (NodePath) var animation_node_path

onready var animation_node : AnimationPlayer = $FadeInOut
onready var dialogue_displayer = $"%DialogueDisplayer"


func _ready():
	StoredData.world_node = self 
	dialogue_displayer.connect("dialogue_finished", self, "_on_DialogueShower_dialogue_finished")
	VolumeSlider.set_menu_visibility(true)
	animation_node.play("FadeIn")


func _on_FadeInOut_animation_finished(anim_name):
	if anim_name == "FadeIn":
		if dialogue_displayer:
			dialogue_displayer.show_first_dialogue()

	if anim_name == "FadeOut":
		go_to_scene(on_fade_out_next_scene.get_path())

func go_to_scene(scene_path: String):
	NotificationManager.deferred_goto_scene(scene_path)

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

