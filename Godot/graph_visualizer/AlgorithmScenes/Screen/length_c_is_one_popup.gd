class_name LengthCIsOnePopup
extends WindowDialog

# This popup interacts with the script 5_if_len_c_equals_1_break.gd
# which makes this popup to appear when the line that contains this script is focused
# This popup will ask for Yes or No: whether the length of the array C is 1
# If the user answers correctly, the user may continue
# No should be the answer the first n-1 times, and the last one should be yes
# The notification manager manages the popup and the actions
# once the user answers correctly, the StoredData singleton will remember that
# the user answered correctly, leting the user to continue


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	NotificationManager.length_c_is_1_popup = self

func _on_YesButton_pressed() -> void:
	NotificationManager._on_YesButton_length_c_is_1_popup_pressed()

func _on_NoButton_pressed() -> void:
	NotificationManager._on_NoButton_length_c_is_1_popup_pressed()

func play_wrong_animation():
	# Visual effect
	$ErrorNotification/AnimationPlayer.stop()
	$ErrorNotification/AnimationPlayer.play("message_modulation")
	# TODO: Add sound effect
