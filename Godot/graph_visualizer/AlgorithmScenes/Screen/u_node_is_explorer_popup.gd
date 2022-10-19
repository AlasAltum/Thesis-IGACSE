class_name UNodeIsExploredPopup
extends WindowDialog


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	NotificationManager.u_is_explored_popup = self
	var close_button : TextureButton = get_close_button()
	close_button.visible = false


func _on_YesButton_pressed() -> void:
	NotificationManager._on_YesButton_pressed()


func _on_NoButton_pressed() -> void:
	NotificationManager._on_NoButton_pressed()

func notify_u_is_explored_wrong_answer():
	# Visual effect
	$ErrorNotification/AnimationPlayer.stop()
	$ErrorNotification/AnimationPlayer.play("message_modulation")
	# TODO: Add sound effect

func _process(delta):
	var a = 3
	
