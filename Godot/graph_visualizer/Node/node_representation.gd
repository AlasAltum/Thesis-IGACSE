class_name NodeRepresentation
extends ADTRepresentation

# Visual Representation of AGraphNode

var index: int = 0

func set_index(_index: int) -> void:
	self.index = _index
#	$Sprite/NodeName.text = str(_index)

func set_selected():
	self.modulate = Color(1.0, 1.0, 0.0, 0.8)

func set_unselected():
	self.modulate = Color(1.0, 1.0, 1.0, 1.0)

func get_initial_position() -> Vector2:
	return Vector2(50.0, 20.0)

func set_properties() -> void:
	self.visible = false

func set_texture(new_texture: StreamTexture) -> void:
	$Sprite.texture = new_texture

func get_class() -> String:
	return "NodeRepresentation"
