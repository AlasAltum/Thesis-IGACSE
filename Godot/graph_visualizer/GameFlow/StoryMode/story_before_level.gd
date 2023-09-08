class_name StoryBeforeLevel
extends Control

# This class will stop a level from initiating until the player checks
# the dialogue

onready var dialogue_displayer = $DialogueCanvas/DialogueDisplayer

signal forward_dialogue_finished

func _ready():
	dialogue_displayer.connect("dialogue_finished", self, "on_forward_finished_signal")

func on_forward_finished_signal():
	call_deferred("custom_free")
	emit_signal("forward_dialogue_finished")

func custom_free():
	self.queue_free()
