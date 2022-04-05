# This class makes sure that when a ADT is pressed,
# the mouse can drag the ADT to the heap.
class_name FollowingMouseTexture
extends Node2D

onready var texture_node: TextureRect = $DataStructureTexture
var resource : Resource

func _ready():
	pass # Replace with function body.

func _process(_delta):
	self.position = get_global_mouse_position()

func set_texture(incoming_texture: Texture):
	self.texture_node.texture = incoming_texture

func get_adt_name():
	if resource:
		return resource.get_adt_name()

func as_variable():
	if resource:
		return resource.as_variable()
