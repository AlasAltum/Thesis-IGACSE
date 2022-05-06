class_name Slot
extends Panel

export (String) var hover_text
export (Texture) var slot_texture
export (Resource) var generated_adt;

onready var texture : TextureRect = $SlotTexture/ADTTexture
onready var hover_label : Label = $Node2D/HoverText
onready var ADT_name : Label = $SlotTexture/BelowADTName

var following_mouse_texture : PackedScene = preload("res://AlgorithmScenes/Screen/FollowingMouseTexture.tscn")

func _ready():
	hover_label.text = self.hover_text
	ADT_name.text = hover_text
	if slot_texture:
		texture.texture = slot_texture


func _on_Area2D_mouse_entered():
	hover_label.visible = true


func _on_Area2D_mouse_exited():
	hover_label.visible = false

# When an ADT is pressed in the menu, create an internal resource
func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if (event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed 
		and not StoredData.dragging_adt):
		# instance texture that follows mouse
		# Instance FollowingMouseTexture		
		StoredData.dragging_adt = true
		var draggable_adt : FollowingMouseTexture = following_mouse_texture.instance()
		draggable_adt.resource = generated_adt.new()
		get_node("/root/Main/CanvasLayer").add_child(draggable_adt)
		StoredData.dragged_adt = draggable_adt
		
