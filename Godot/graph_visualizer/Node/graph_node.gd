extends KinematicBody2D
class_name AGraphNode

onready var node_name: Label = $Sprite/NodeName
var selected : bool = false
var index : int = 0
var edges : Array
var radius: int = 200
var pressed: bool = false

var can_grab: bool = false
var grabbed_offset: Vector2 = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Nodes")
	randomize()

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
	node_name.text = str(self.index)

func set_edges(_edges: Array):
	self.edges = _edges

func on_simple_press():
	self.selected = true
	self.modulate = Color(1.0, 1.0, 0.0, 0.8)
	node_name.modulate = Color(0.0, 1.0, 0.0, 1.0)


func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		can_grab = event.pressed
		grabbed_offset = position - get_global_mouse_position()

func _process(_delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and can_grab:
		position = get_global_mouse_position() + grabbed_offset


