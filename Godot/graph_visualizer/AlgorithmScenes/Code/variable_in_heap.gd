extends Label

onready var area_2d : Area2D = $Area2D
onready var collision_object: CollisionShape2D = $Area2D/CollisionShape2D
var collision_shape: RectangleShape2D = null

signal variable_clicked


func _ready():
	collision_object.shape = RectangleShape2D.new()
	collision_shape = collision_object.shape
	$Area2D.connect("input_event", self, "_on_Area2D_input_event")
	adjust_collision_shape()

func _on_Variable_resized():
	adjust_collision_shape()

func adjust_collision_shape():
	# match collision shape exactly with rect
	# The size of the collision shape will be the same as the size of this label
	collision_shape.extents = self.rect_size / 2
	# The position of the collision shape is the center of this rect
	area_2d.global_position = self.rect_global_position + self.rect_size / 2

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		emit_signal("variable_clicked")
