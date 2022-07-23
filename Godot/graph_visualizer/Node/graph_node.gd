class_name AGraphNode
extends KinematicBody2D

var selected : bool = false
var index : int = 0
var edges : Array setget set_edges, get_edges
var radius: int = 200
var pressed: bool = false


onready var node_name: Label = $Sprite/NodeName
onready var popup_menu: Popup = $Popup

const representation_prefab = preload("res://Node/NodeRepresentation.tscn")
var adt_type = load("res://AlgorithmScenes/Code/ADTs/node_adt.gd")

var representation 
var adt  #: NodeADT


var can_grab: bool = false
var grabbed_offset: Vector2 = Vector2()

const NORMAL_COLOR = Color(1.0, 1.0, 1.0, 1.0)
const ITERATED_COLOR = Color(0.7, 0.4, 0.2)
const SELECTED_COLOR = Color(1.0, 1.0, 0.0, 0.8)
const SELECTED_LABEL_COLOR = Color(0.0, 1.0, 0.0, 1.0)

signal node_add_to_object_request(node)


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Nodes")
	self.representation = self.get_representation()
	self.adt = adt_type.new(self)
	randomize()

func get_adt():
	return self.adt

func get_representation():
	self.representation = representation_prefab.instance()
	self.representation.set_index(self.index)
	if self.selected:
		self.representation.set_selected()

	return self.representation

func init_radial_position(total_nodes: int):
	var angle = 2 * PI / (total_nodes + 1) * (self.index + 1)
	self.position = Vector2(cos(angle) * radius + 550, sin(angle) * radius + 350)
	return self.position

func init_random_position(left, right, down, up):
	self.position = Vector2(
		rand_range(left, right), rand_range(down, up)
	)
	return self.position

func set_index(_index: int):
	self.index = _index
	representation.set_index(_index)
	node_name.text = str(_index)

# Edges type is:
# pairs<node_index <int>, weight <float>>
func set_edges(_edges: Array) -> void:
	edges = _edges

# Returns an array of pairs with type:
# pairs<node_index <int>, weight <float>>:
func get_edges() -> Array:
	return edges

func set_selected():
	self.selected = true
	self.modulate = SELECTED_COLOR
	node_name.modulate = SELECTED_LABEL_COLOR
	representation.set_selected()
	# This array is not being used anymore
	# Now it is created each time it is queried
	#	StoredData.selected_nodes.append(self)

func mark_as_iterated():
	self.modulate = ITERATED_COLOR

# Select node using left click
func on_simple_press_left():
	set_selected()

# Right click menu and actions
func on_simple_press_right():
	popup_menu.popup()
	popup_menu.set_position(self.position)

# with right click menu
func _on_UnselectButton_pressed():
	self.selected = false
	self.modulate = NORMAL_COLOR
	node_name.modulate = NORMAL_COLOR
	representation.set_unselected()
	popup_menu.hide()
	popup_menu.visible = false
	# StoredData.selected_nodes.erase(self)

## Right click menu related methods ##
func _on_AddToObjectButton_pressed():
	emit_signal("node_add_to_object_request", self)
	popup_menu.visible = false

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		can_grab = event.pressed
		grabbed_offset = position - get_global_mouse_position()
#
func _process(_delta):
	if can_grab:
		if Input.is_mouse_button_pressed(BUTTON_LEFT):
			match StoredData.get_status():
				StoredData.mov_status.DRAG:
					position = get_global_mouse_position() + grabbed_offset
				StoredData.mov_status.SELECT:
					if self.index in StoredData.selectable_nodes:
						on_simple_press_left()

#		elif Input.is_mouse_button_pressed(BUTTON_RIGHT):
#			match StoredData.get_status():
#				StoredData.mov_status.SELECT:
#					on_simple_press_right()

## Right click menu related methods ##

func as_string() -> String:
	return "(" + str(self.index) + ")"


# Show hover menu
func _on_Area2D_mouse_entered() -> void:
	popup_menu.set_position(self.position + Vector2(45.0, -30.0))
	popup_menu.popup()

# Unshow hover menu
func _on_Area2D_mouse_exited() -> void:
	popup_menu.hide()
