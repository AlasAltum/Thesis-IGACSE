extends RichTextLabel

func _ready() -> void:
	NotificationManager.hint_label = self

func set_allow_code_advance(value: bool):
	NotificationManager.allow_code_advance = value
