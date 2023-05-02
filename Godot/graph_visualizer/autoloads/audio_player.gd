extends Node

# TODO: click on edge 
var button_sound = preload("res://Assets/sound/menu_button_click _trimmed.mp3")

onready var button_sound_player = $ButtonSoundPlayer
onready var music_player = $MusicPlayer



func _ready():
	pass


func play_button_sound():
	button_sound_player.play()
