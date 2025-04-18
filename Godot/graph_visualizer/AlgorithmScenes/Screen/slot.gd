class_name ADTSlot
extends Container

# A slot contains a Data Structure.
# If the user presses a slot with a data structure, a popup
# should prompt asking the user for a name for the new structure

export (String) var hover_text
export (Texture) var slot_texture
export (Resource) var generated_adt  # The ADT for the corresponding slot
export (PackedScene) var on_hover_animation

onready var texture : TextureRect = $SlotTexture/ADTTexture
onready var hover_panel : Node2D = $HoverPanel
onready var hover_label : Label = $HoverPanel/ColorRect/HoverText
onready var ADT_name : Label = $SlotTexture/BelowADTName

var hover_animation_instance: Node2D


func _ready():
	# Add label to hover and animation
	if on_hover_animation:
		hover_label.text = self.hover_text	
		hover_animation_instance = on_hover_animation.instance()
		hover_panel.get_node("ColorRect").add_child(hover_animation_instance)
		# We have a placeholder with different positions, use this position and then
		# erase this variable
		hover_animation_instance.position = $HoverPanel/ColorRect/AnimationPlaceholder.position
		$HoverPanel/ColorRect/AnimationPlaceholder.queue_free()
		ADT_name.text = hover_text

	if slot_texture and texture:
		texture.texture = slot_texture

func _mouse_is_inside_rect() -> bool:
	return $SlotTexture.get_rect().has_point(get_global_mouse_position())

func _on_Area2D_mouse_entered():
	hover_panel.visible = true
	if hover_animation_instance:
		hover_animation_instance.play_animation()

func _on_Area2D_mouse_exited():
	hover_panel.visible = false
	if hover_animation_instance:
		hover_animation_instance.stop_animation()

# When an ADT is left clicked on the menu, create an internal resource
func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if _event_is_click(event):
		_create_adt()

func _create_adt():
	if generated_adt:
		StoredData.adt_to_be_created = generated_adt.new()
		NotificationManager._on_variable_creation_popup(ADT_name.text)

func _event_is_click(event) -> bool:
	return event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed
