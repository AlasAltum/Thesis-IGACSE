extends Node


var bg1_audio = preload("res://AlgorithmScenes/Audio/music/bg1.mp3") 
var bg2_audio = preload("res://AlgorithmScenes/Audio/music/bg2.mp3")
var bg3_audio = preload("res://AlgorithmScenes/Audio/music/bg3.mp3")
var bg4_audio = preload("res://AlgorithmScenes/Audio/music/bg4.mp3")

onready var button_sound_player : AudioStreamPlayer = $ButtonSoundPlayer
onready var music_player : AudioStreamPlayer = $MusicPlayer



func _ready():
	pass


func play_button_sound():
	button_sound_player.play()

func play_background_by_index(index: int):
	match index:
		0:
			play_bg1()
		1: 
			play_bg2()
		3:
			play_bg3()
		_:
			play_bg4()
	music_player.play()

func play_bg1():
	music_player.set_stream(bg1_audio)

func play_bg2():
	music_player.set_stream(bg2_audio)

func play_bg3():
	music_player.set_stream(bg3_audio)

func play_bg4():
	music_player.set_stream(bg4_audio)
