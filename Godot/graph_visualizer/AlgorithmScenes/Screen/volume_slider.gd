extends Control

export var audio_bus_name := "Master"

onready var _bus := AudioServer.get_bus_index(audio_bus_name)
onready var hslider = $HBoxContainer/HSlider
onready var audio_texture_button : TextureButton = $HBoxContainer/AudioTextureButton


func _ready() -> void:
	hslider.value = db2linear(AudioServer.get_bus_volume_db(_bus))
	audio_texture_button.toggle_mode = true
	audio_texture_button.set_pressed(false)


func _on_HSlider_value_changed(value: float):
	AudioServer.set_bus_volume_db(_bus, linear2db(value))
	if value < 0.05:
		audio_texture_button.set_pressed(true)
		AudioServer.set_bus_volume_db(_bus, linear2db(0.0))
	else:
		audio_texture_button.set_pressed(false)
