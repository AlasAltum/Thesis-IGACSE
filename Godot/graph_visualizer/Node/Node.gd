extends Sprite
class_name AGraphNode

onready var area : Area2D = $Area2D
onready var node_name: Label = $NodeName
var selected : bool = false
var index : int
var edges : Array
var radius = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	area.receiver_node = self
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

func _on_presed():
	self.selected = true
	self.modulate = Color(1.0, 1.0, 0.0, 0.8)
	node_name.modulate = Color(0.0, 1.0, 0.0, 1.0)
	# var font = node_name.get("custom_fonts/font")

