extends KinematicBody2D
class_name AGraphNode

var selected : bool = false
var index : int = 0
var edges : Array
var radius: int = 200
var pressed: bool = false
onready var node_name: Label = $Sprite/NodeName
onready var popup_menu: Popup = $Popup

var can_grab: bool = false
var grabbed_offset: Vector2 = Vector2()

signal node_add_to_object(node)


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

func set_selected():
	self.selected = true
	self.modulate = Color(1.0, 1.0, 0.0, 0.8)
	node_name.modulate = Color(0.0, 1.0, 0.0, 1.0)
	# StoredData.selected_nodes.append(self)

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
	self.modulate = Color(1.0, 1.0, 1.0, 1.0)
	node_name.modulate = Color(1.0, 1.0, 1.0, 1.0)
	popup_menu.hide()
	popup_menu.visible = false
	# StoredData.selected_nodes.erase(self)

# With right click menu
func _on_AddToObjectButton_pressed():
	emit_signal("node_add_to_object", self)
	popup_menu.visible = false

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		can_grab = event.pressed
		grabbed_offset = position - get_global_mouse_position()

func _process(_delta):
	if can_grab:

		if Input.is_mouse_button_pressed(BUTTON_LEFT):
			match StoredData.get_status():
				StoredData.mov_status.DRAG:
					position = get_global_mouse_position() + grabbed_offset
				StoredData.mov_status.SELECT:
					on_simple_press_left()


		elif Input.is_mouse_button_pressed(BUTTON_RIGHT):
			match StoredData.get_status():
				StoredData.mov_status.SELECT:
					on_simple_press_right()


func as_string() -> String:
	return "Node(" + str( self.index) + ")"
