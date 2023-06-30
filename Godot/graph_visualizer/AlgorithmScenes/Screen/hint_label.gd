extends RichTextLabel

func _ready() -> void:
	NotificationManager.hint_label = self

# Called in animation BFS_tutorial.tscn TextHintContainer/HintLabel
func set_allow_code_advance(value: bool):
	NotificationManager.allow_code_advance = value
