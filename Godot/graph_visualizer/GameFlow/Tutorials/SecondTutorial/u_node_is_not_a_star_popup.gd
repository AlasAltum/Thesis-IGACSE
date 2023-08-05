class_name UNodeIsNotAStarPopup
extends WindowDialog

func _ready():
	get_close_button().visible = false

func _notification(what):
	if what == NOTIFICATION_POST_POPUP:
		StoredData.popup_captures_input = true
		$MarginContainer/VBoxContainer/HBoxContainer/YesButton.grab_focus()
	elif what == NOTIFICATION_POPUP_HIDE:
		StoredData.popup_captures_input = false

func _on_YesButton_pressed() -> void:
	if StoredData.world_node.u_is_not_a_star_correct_answer:  # Wrong answer
		notify_u_is_a_star_wrong_answer()
	else:  # Expected answer
		notify_u_is_a_star_correct_answer()

func _on_NoButton_pressed() -> void:
	if StoredData.world_node.u_is_not_a_star_correct_answer: # Expected answer
		notify_u_is_a_star_correct_answer()
	else:    # Wrong answer
		notify_u_is_a_star_wrong_answer()


func notify_u_is_a_star_wrong_answer():
	# Visual effect
	$"%ErrorNotification/AnimationPlayer".stop()
	$"%ErrorNotification/AnimationPlayer".play("message_modulation")
	AudioPlayer.play_error_audio()
	StoredData.world_node.send_ship_to_the_sun()

func notify_u_is_a_star_correct_answer():
	# set the correct answer to true, so the script can advance and is marked as correct
	StoredData.world_node.u_is_not_a_star_correct_answer = true
	self.hide()
