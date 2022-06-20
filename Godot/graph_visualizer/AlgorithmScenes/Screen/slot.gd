class_name Slot
extends Panel

export (String) var hover_text
export (Texture) var slot_texture
export (Resource) var generated_adt;
export (PackedScene) var on_hover_animation

onready var texture : TextureRect = $SlotTexture/ADTTexture
onready var hover_panel : Node2D = $HoverPanel
onready var hover_label : Label = $HoverPanel/ColorRect/HoverText
onready var ADT_name : Label = $SlotTexture/BelowADTName

var following_mouse_texture : PackedScene = preload("res://AlgorithmScenes/Screen/GUI/FollowingMouseTexture.tscn")
var hover_animation_instance: Node2D

func _ready():
	# Add label to hover and animation
	if on_hover_animation:
		hover_label.text = self.hover_text	
		hover_animation_instance = on_hover_animation.instance()
		hover_panel.get_node("ColorRect").add_child(hover_animation_instance)
		hover_animation_instance.position = $HoverPanel/ColorRect/AnimationPlaceholder.position
		$HoverPanel/ColorRect/AnimationPlaceholder.queue_free()
		ADT_name.text = hover_text

	if slot_texture:
		texture.texture = slot_texture


func _on_Area2D_mouse_entered():
	if hover_animation_instance:
		hover_panel.visible = true
		hover_animation_instance.play_animation()


func _on_Area2D_mouse_exited():
	if hover_animation_instance:
		hover_panel.visible = false
		hover_animation_instance.stop_animation()

# When an ADT is pressed in the menu, create an internal resource
func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if (event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed 
		and not StoredData.dragging_adt):
		# instance texture that follows mouse
		# Instance FollowingMouseTexture		
		StoredData.dragging_adt = true
		var draggable_adt = following_mouse_texture.instance()
		draggable_adt.resource = generated_adt.new()
		get_node("/root/Main/CanvasLayer").add_child(draggable_adt)
		StoredData.dragged_adt = draggable_adt
		
