class_name Slot
extends Panel

export (String) var hover_text
export (Texture) var slot_texture
export (Resource) var generated_adt;

onready var texture : TextureRect = $SlotTexture/TextureRect
onready var hover_label : Label = $Node2D/HoverText
var following_mouse_texture : PackedScene = preload("res://AlgorithmScenes/Screen/FollowingMouseTexture.tscn")

func _ready():
	hover_label.text = self.hover_text
	if slot_texture:
		texture.texture = slot_texture


func _on_Area2D_mouse_entered():
	hover_label.visible = true


func _on_Area2D_mouse_exited():
	hover_label.visible = false

func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if (event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed 
		and not StoredData.dragging_adt):
		# instance texture that follows mouse
		# Instance FollowingMouseTexture
		var draggable_adt : FollowingMouseTexture = following_mouse_texture.instance()
		get_node("/root/Main/CanvasLayer").add_child(draggable_adt)
		StoredData.dragging_adt = true
		draggable_adt.resource = generated_adt
		StoredData.dragged_adt = draggable_adt
