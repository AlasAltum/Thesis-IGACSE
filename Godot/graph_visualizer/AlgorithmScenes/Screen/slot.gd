class_name Slot
extends Panel

export (String) var hover_text
export (Texture) var slot_texture

onready var texture : TextureRect = $SlotTexture/TextureRect
onready var hover_label : Label = $Node2D/HoverText


func _ready():
	hover_label.text = self.hover_text
	if slot_texture:
		texture.texture = slot_texture


func _on_Area2D_mouse_entered():
	hover_label.visible = true


func _on_Area2D_mouse_exited():
	hover_label.visible = false
