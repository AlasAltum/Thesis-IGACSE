class_name AGraphNode
extends KinematicBody2D


var selected : bool = false
var index : int = 0
var edges : Array setget set_edges, get_edges
var radius: int = 200
var pressed: bool = false
var aux_position: Vector2
var clickable = false
var node_color: Color setget set_color, get_color

onready var node_name: Label = $Sprite/NodeName
onready var popup_menu: Popup = $Popup
onready var select_unselect_button: Button = $Popup/PanelContainer/VBoxContainer/SelectUnselectButton
onready var add_to_object_button: Button = $Popup/PanelContainer/VBoxContainer/AddToObjectButton

const representation_prefab = preload("res://Node/NodeRepresentation.tscn")
var adt_type = load("res://AlgorithmScenes/Code/ADTs/node_adt.gd")

enum MOUSE_STATUS {INSIDE, OUTSIDE}

var mouse_status = MOUSE_STATUS.OUTSIDE
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


const FACTOR_TO_KEEP_NODES_IN_CONTAINER = 0.9
# Initializes the position of a node inside the node container considering its dimensions
# So nodes are better spacially distributed in the container
# node_container_positions contains: [center_position, container_size]
func init_position_regarding_container(total_nodes: int, node_container_key_properties: Array):
	var angle = 2 * PI / (total_nodes + 1) * (self.index + 1)
	var radius_x = node_container_key_properties[1].x  # X size
	var radius_y = node_container_key_properties[1].y  # Y size
	aux_position = node_container_key_properties[0]  # Start at center position
	# We add this 0.9 so nodes are not out of the container
	aux_position += Vector2(
		cos(angle) * radius_x * FACTOR_TO_KEEP_NODES_IN_CONTAINER,
		sin(angle) * radius_y * FACTOR_TO_KEEP_NODES_IN_CONTAINER
	)

	self.position = to_local(aux_position)
	aux_position = to_local(aux_position)


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

func mark_as_iterated():
	self.select_node()
	self.modulate = ITERATED_COLOR
	if not self in StoredData.iterated_nodes: 
		StoredData.iterated_nodes.append(self)

## Right click menu related methods ##
func as_string() -> String:
	return "(" + str(self.index) + ")"

# When using the hover menu and pressing Q, or when clicking the node
# To  toggle select/unselect a node
func _on_Select_UnselectButton_pressed():
	# Unselect
	if self.selected:
		pass
		#self.unselect_node()
	else:
		self.select_node()
	self.hide_popup_menu()

func unselect_node():
	self.selected = false
	self.modulate = NORMAL_COLOR
	node_name.modulate = NORMAL_COLOR
	representation.set_unselected()
	popup_menu.hide()
	popup_menu.visible = false

func select_node():
	if self.index in StoredData.selectable_nodes:
		self.selected = true
		self.modulate = SELECTED_COLOR
		node_name.modulate = SELECTED_LABEL_COLOR
		representation.set_selected()
	else:
		# TODO: Add animation: Error, not selectable node!
		print("Not selectable Node")


func _on_AddToObjectButton_pressed():
	get_added_to_focused_object_in_variables()
	popup_menu.visible = false

func get_added_to_focused_object_in_variables():
	emit_signal("node_add_to_object_request", self)


func _input(event):
	# Menu must be open to allow these options
	if event is InputEventKey and self.mouse_status == MOUSE_STATUS.INSIDE:
		# Q action corresponds to add select the node
		if Input.is_key_pressed(KEY_Q):
			_on_Select_UnselectButton_pressed()
		# W Action 
		elif Input.is_key_pressed(KEY_W):
			get_added_to_focused_object_in_variables()

		hide_popup_menu()


# Show hover menu
func _on_Area2D_mouse_entered() -> void:
	popup_menu.set_position(get_global_mouse_position())
	self.mouse_status = MOUSE_STATUS.INSIDE
	popup_menu.popup()

# Hide hover menu
func _on_Area2D_mouse_exited() -> void:
	self.hide_popup_menu()
	self.mouse_status = MOUSE_STATUS.OUTSIDE

# Click on the node = Press select/unselect node
func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if _event_is_left_click(event):
		_on_Select_UnselectButton_pressed()

func _event_is_left_click(event):
	return (event is InputEventMouseButton and
		event.button_index == BUTTON_LEFT and
		event.pressed)


# This method must be repeated, because a click can be considered as a mouse exited from the area2D.
func hide_popup_menu():
	popup_menu.hide()
	self.clickable = false

func set_color(in_color: Color) -> void:
	node_color = in_color
	$Sprite.material.set_shader_param("assigned_color", in_color)

func get_color() -> Color:
	return  $Sprite.material.get_shader_param("assigned_color")
