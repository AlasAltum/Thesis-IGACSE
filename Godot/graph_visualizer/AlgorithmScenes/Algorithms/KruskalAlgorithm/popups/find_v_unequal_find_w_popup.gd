class_name FindWUnequalFindVPopup
extends WindowDialog

# Kruskal Code, popup that shows
# if (find(w) != find(v))


# Called when the node enters the scene tree for the first time.
func _ready():
	NotificationManager._find_w_unequal_find_v_popup = self
	var close_button : TextureButton = get_close_button()
	close_button.visible = false

func _on_YesButton_pressed() -> void:
	NotificationManager._on_YesButton_find_w_unequal_find_v_pressed()

func _on_NoButton_pressed() -> void:
	NotificationManager._on_NoButton_find_w_unequal_find_v_pressed()

func play_wrong_animation():
	# Visual effect
	$ErrorNotification/AnimationPlayer.stop()
	$ErrorNotification/AnimationPlayer.play("message_modulation")
	AudioPlayer.play_error_audio()


func _notification(what):
	if what == NOTIFICATION_POST_POPUP:
		StoredData.popup_captures_input = true
		$YesButton.grab_focus()
	elif what == NOTIFICATION_POPUP_HIDE:
		StoredData.popup_captures_input = false

