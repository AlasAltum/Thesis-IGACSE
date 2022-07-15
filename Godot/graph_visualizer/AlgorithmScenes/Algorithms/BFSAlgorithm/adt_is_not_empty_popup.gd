class_name ADTIsEmptyPopup
extends WindowDialog


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	NotificationManager.adt_is_empty_popup = self


func _on_adt_is_empty_YesButton_pressed() -> void:
	NotificationManager._on_adt_is_empty_YesButton_pressed()

func _on_adt_is_empty_NoButton_pressed() -> void:
	NotificationManager._on_adt_is_empty_NoButton_pressed()

func play_wrong_animation():
	$ErrorNotification/AnimationPlayer.stop()
	$ErrorNotification/AnimationPlayer.play('message_modulation')
