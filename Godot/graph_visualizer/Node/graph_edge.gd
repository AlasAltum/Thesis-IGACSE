# class_name GraphEdge
# extends PinJoint2D


# var weight: float = 1.0;
# var joint_end1: Node2D
# var joint_end2: Node2D
# var collision_line: CollisionShape2D
# var clickable_area: RectangleShape2D


# onready var curr_label: Label = $Label
# onready var line: Line2D = $Line2D


# func _ready():
# 	self.set_process(false)
# 	collision_line = $Area2D/LineCollision
# 	if collision_line.shape.get_class() == "RectangleShape2D":
# 		clickable_area = collision_line.shape


# # Used to keep the lines connected to the nodes and the weight position
# func _process(_delta):
# 	line.set_point_position(0, get_node(node_a).position)
# 	line.set_point_position(1, get_node(node_b).position)
# 	curr_label.set_position(
# 		(get_node(node_a).position + get_node(node_b).position) / 2
# 	)


# func set_label_and_positions_with_nodes(node1: Node2D, node2: Node2D, label_text: String):
# 	var line_vertices = PoolVector2Array([node1.position, node2.position])
# 	line.points = line_vertices
# 	curr_label.text = label_text
# 	self.z_index = -1
# 	self.set_process(true)
# 	self.joint_end1 = node1
# 	self.joint_end2 = node2
# 	self.node_a = node1.get_path()
# 	self.node_b = node2.get_path()


# func set_collision_box():
# 	var pos1: Vector2 = joint_end1.aux_position
# 	var pos2: Vector2 = joint_end2.aux_position
# 	var distance: float = sqrt(
# 		(pos2.y - pos1.y) * (pos2.y - pos1.y) + (pos2.x - pos1.x) * (pos2.x - pos1.x)
# 	) - 60.0
# 	clickable_area.extents = Vector2(distance * 1/2, 8.0);
# 	collision_line.position = (pos1 + pos2) / 2.0;
# 	collision_line.rotation = atan2(pos2.y - pos1.y, pos2.x - pos1.x);
# 	collision_line.shape = clickable_area
