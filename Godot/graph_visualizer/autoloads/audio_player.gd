extends Node


var bg1_audio = preload("res://AlgorithmScenes/Audio/music/bg1.mp3") 
var bg2_audio = preload("res://AlgorithmScenes/Audio/music/bg2.mp3")
var bg3_audio = preload("res://AlgorithmScenes/Audio/music/bg3.mp3")
var bg4_audio = preload("res://AlgorithmScenes/Audio/music/bg4.mp3")

onready var button_sound_player : AudioStreamPlayer = $ButtonSoundPlayer
onready var music_player : AudioStreamPlayer = $MusicPlayer
onready var element_selected : AudioStreamPlayer = $ElementSelectedPlayer
onready var error_audio: AudioStreamPlayer = $ErrorAudioPlayer
onready var confirmation_audio: AudioStreamPlayer = $ConfirmationAudioPlayer
onready var not_doable_action_player_audio: AudioStreamPlayer = $NotDoableActionAudioPlayer
onready var congratulations_audio: AudioStreamPlayer = $CongratulationsAudioPlayer
onready var pop_audio: AudioStreamPlayer = $PopAudioPlayer


func _ready():
	pass


func play_button_sound():
	button_sound_player.play()

func play_element_selected():
	element_selected.play()

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

func stop_playing_music():
	music_player.stop()

# The notification manager notifies about the error because
# There can be other added effects, and this object should only care about sound
func play_error_audio():
	error_audio.play()

func play_not_doable_action_sound():
	play_error_audio()

func play_confirmation_audio():
	confirmation_audio.play()

func play_congratulations_audio():
	congratulations_audio.play()

func play_pop_sound():
	pop_audio.play()
