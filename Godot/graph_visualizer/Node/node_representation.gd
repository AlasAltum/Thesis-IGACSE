class_name NodeRepresentation
extends ADTRepresentation

# Visual Representation of AGraphNode

var index: int = 0

func _ready() -> void:
	self.position = Vector2(95.0, 60.0)
	self.scale = Vector2(2.0, 2.0)

func set_index(_index: int) -> void:
	self.index = index
	$Sprite/NodeName.text = str(_index)

func set_selected():
	self.modulate = Color(1.0, 1.0, 0.0, 0.8)
	$Sprite/NodeName.modulate = Color(0.0, 1.0, 0.0, 1.0)

func set_unselected():
	self.modulate = Color(1.0, 1.0, 1.0, 1.0)
	$Sprite/NodeName.modulate = Color(1.0, 1.0, 1.0, 1.0)

func get_initial_position() -> Vector2:
	return Vector2(50.0, 20.0)

func set_properties() -> void:
	self.visible = false
	
