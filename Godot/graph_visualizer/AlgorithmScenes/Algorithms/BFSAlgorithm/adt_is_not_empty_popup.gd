class_name ADTIsEmptyPopup
extends WindowDialog

export (String) var ADT_type_and_var_name = "Queue q"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	NotificationManager.adt_is_empty_popup = self
	get_close_button().visible = false
	set_text(self.ADT_type_and_var_name)

func set_text(ADT_type_name: String) -> void:
	var explanation_label: Label = $VB/Explanation
	var explanation = "Is the {ADT_type_name} empty?"
	match TranslationServer.get_locale():
		"es":
			explanation = "Está la estructura {ADT_type_name} vacía?"

	explanation = explanation.format({"ADT_type_name": ADT_type_name})
	explanation_label.text = explanation

func _notification(what):
	if what == NOTIFICATION_POST_POPUP:
		StoredData.popup_captures_input = true
		$"%YesButton".grab_focus()
		$"%YesButton".grab_click_focus()
	elif what == NOTIFICATION_POPUP_HIDE:
		StoredData.popup_captures_input = false

func _on_adt_is_empty_YesButton_pressed() -> void:
	NotificationManager._on_adt_is_empty_YesButton_pressed()

func _on_adt_is_empty_NoButton_pressed() -> void:
	NotificationManager._on_adt_is_empty_NoButton_pressed()

func play_wrong_animation():
	if $"%AnimationPlayer":
		$"%AnimationPlayer".stop()
		$"%AnimationPlayer".play('message_modulation')


func _on_ADTIsNotEmptyPopup_popup_hide():
	StoredData.popup_captures_input = false

