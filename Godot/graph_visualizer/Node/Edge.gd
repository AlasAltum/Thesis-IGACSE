extends PinJoint2D
class_name Edge

onready var curr_label = $Label
onready var line = $Line2D
onready var edge_collision : CollisionShape2D = $Area2D/LineCollision
var weight = 1
var connecting_nodes = [] # [AGraphNode, AGraphNode]

var joint_end1 : Node2D
var joint_end2 : Node2D

var process : bool = false


func _ready():
	self.set_process(false)


func _process(_delta):
	line.points[0] = joint_end1.position
	line.points[1] = joint_end2.position
#	curr_label.set_position( (position1 + position2) / 2 )
	
func set_shape(position1, position2):
	var shape = SegmentShape2D.new()
	shape.a = position1
	shape.b = position2
	edge_collision.set_shape(shape)

func set_label_and_positions(position1: Vector2, position2: Vector2, label: String):
	line.points = PoolVector2Array([position1, position2])
	set_shape(position1, position2)
	curr_label.text = label

	curr_label.set_position( (position1 + position2) / 2 )
	self.set_z_index(-1)
	self.set_process(true)


func set_label_and_positions_with_nodes(node1: AGraphNode, node2: AGraphNode, label: String):
	line.points = PoolVector2Array([node1.position, node2.position])
	set_shape(node1.position, node2.position)
	curr_label.text = label
	curr_label.set_position( (node1.position + node2.position) / 2 )
	self.set_z_index(-1)

	joint_end1 = node1
	joint_end2 = node2
	self.node_a = node1.get_path()
	self.node_b = node2.get_path()
	self.set_process(true)
