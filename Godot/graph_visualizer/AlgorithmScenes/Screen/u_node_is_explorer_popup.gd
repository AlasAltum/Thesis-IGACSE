class_name UNodeIsExploredPopup
extends WindowDialog


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	NotificationManager.u_is_explored_popup = self
	var close_button : TextureButton = get_close_button()
	close_button.visible = false

func _notification(what):
	if what == NOTIFICATION_POST_POPUP:
		StoredData.popup_captures_input = true
		$YesButton.grab_focus()
	elif what == NOTIFICATION_POPUP_HIDE:
		StoredData.popup_captures_input = false

func _on_YesButton_pressed() -> void:
	NotificationManager._on_YesButton_pressed()


func _on_NoButton_pressed() -> void:
	NotificationManager._on_NoButton_pressed()

func notify_u_is_explored_wrong_answer():
	# Visual effect
	$ErrorNotification/AnimationPlayer.stop()
	$ErrorNotification/AnimationPlayer.play("message_modulation")
	NotificationManager.play_error_audio()
