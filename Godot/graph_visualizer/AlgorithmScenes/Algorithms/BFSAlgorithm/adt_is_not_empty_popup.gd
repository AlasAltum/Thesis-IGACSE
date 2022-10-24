class_name ADTIsEmptyPopup
extends WindowDialog

export (String) var ADT_type_and_var_name = "Queue q"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	NotificationManager.adt_is_empty_popup = self
	var close_button : TextureButton = get_close_button()
	close_button.visible = false
	set_text(self.ADT_type_and_var_name)

func set_text(ADT_type_name: String) -> void:
	var explanation_label: Label = $Explanation
	var explanation = "Is the {ADT_type_name} empty?"
	explanation = explanation.format({"ADT_type_name": ADT_type_name})
	explanation_label.text = explanation


func _on_adt_is_empty_YesButton_pressed() -> void:
	NotificationManager._on_adt_is_empty_YesButton_pressed()

func _on_adt_is_empty_NoButton_pressed() -> void:
	NotificationManager._on_adt_is_empty_NoButton_pressed()

func play_wrong_animation():
	$ErrorNotification/AnimationPlayer.stop()
	$ErrorNotification/AnimationPlayer.play('message_modulation')

func _on_ADTIsNotEmptyPopup_about_to_show():
	StoredData.popup_captures_input = true
	$YesButton.grab_focus()
	$YesButton.grab_click_focus()

func _on_ADTIsNotEmptyPopup_popup_hide():
	StoredData.popup_captures_input = false
