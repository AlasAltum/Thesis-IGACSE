class_name GraphEdge
extends PinJoint2D


const adt_type = preload("res://AlgorithmScenes/Code/ADTs/edge_adt.gd")
var adt: ADT

const highlighted_material = preload("res://Assets/custom_shaders/edge_hightlight_material.tres")

onready var collision_line: CollisionShape2D = $Area2D/LineCollision
onready var curr_label: Label = $Label
onready var ship_path: Path2D = $ShipPath
onready var ship_path_follow: PathFollow2D = $ShipPath/ShipPathFollow
onready var ship_animation_player: AnimationPlayer = $ShipPath/ShipAnimationPlayer
onready var shipSprite: Sprite = $ShipPath/ShipPathFollow/Sprite
onready var line: Line2D = $Line2D

export var clickable_area: RectangleShape2D

export var weight: float = 1.0
export var is_selected: bool = false
var joint_end1: Node2D
var joint_end2: Node2D

func _ready():
	self.z_index = -3
	set_process(false)
	clickable_area = collision_line.shape as RectangleShape2D
	adt = adt_type.new(self)

func _process(delta: float) -> void:
	line.set_point_position(0, joint_end1.global_position)
	line.set_point_position(1, joint_end2.global_position)

	curr_label.set_position(
		(joint_end1.global_position + joint_end2.global_position) / 2
	)
	set_collision_box()


func value_is_close_to(value1: float, value2: float, tolerance: float) -> bool:
	return abs(value1 - value2) < tolerance

func radians_to_degrees(angle: float) -> float:
	return angle * 180 / PI

# Make sure Labels are not that much rotated so they are always readable
# Rotation is coming in radians
func normalize_rotation(rotation: float) -> float:
	# Make 90° labels vertical by not rotating them 
	if value_is_close_to(rotation, PI/2, 0.05) or value_is_close_to(rotation, -PI/2, 0.05) or value_is_close_to(rotation, PI, 0.05):
		return 0.0
	# Turn label until rotation is between [-90°, 90°] degrees
	while abs(radians_to_degrees(rotation)) > 90.0:
		if radians_to_degrees(rotation) > 90.0:
			rotation -= PI
		# lower than -150 degrees => 30 degrees
		elif radians_to_degrees(rotation) < -90.0:
			rotation += PI
	return rotation


func set_label_and_positions_with_nodes(node1: Node2D, node2: Node2D, label_text: String) -> void:
	var line_vertices = [node1.global_position, node2.global_position]
	line.points = line_vertices

	if label_text != "":
		curr_label.text = label_text
		weight = float(label_text) # we prefer to receive a string and turn it into a float
		var node1_pos = node1.get("aux_position")
		var node2_pos = node2.get("aux_position")
		var difference = node2_pos - node1_pos
		var rotation = atan2(difference.y, difference.x)
		rotation = normalize_rotation(rotation)
		curr_label.set_rotation(rotation)

	# This is requested when we allow graph movement
	set_process(true)
	joint_end1 = node1
	joint_end2 = node2
	node_a = node1.get_path()
	node_b = node2.get_path()
	set_collision_box()
	return

const SUBJECTIVE_NODE_RADIUS = 60.0
# To set this quad, we will set the extent of the rectangle like the following
# extent(x, y) := y will be its margin, x will be its distance
# position(x, y) := (node1.position + node2.position) / 2
# rotation(alpha) := arctan( (node2.y - node1.y) / (node2.x - node1.x) )
# There are some hardcoded values, these may change depending on the edge textures
# and other factors.
func set_collision_box() -> void:
	# Set extent of the collision box for the line
	var pos1 = joint_end1.global_position
	var pos2 = joint_end2.global_position

	var distance = sqrt(
		(pos2.y - pos1.y) * (pos2.y - pos1.y) + (pos2.x - pos1.x) * (pos2.x - pos1.x)
	) - SUBJECTIVE_NODE_RADIUS
	clickable_area.extents = Vector2(distance * 0.5, 8.0)
	# Set the position of the collision box
	collision_line.global_position = (pos1 + pos2) * 0.5
	collision_line.rotation = atan2(pos2.y - pos1.y, pos2.x - pos1.x)


func event_is_left_click(event: InputEvent) -> bool:
	return event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed

func _on_Area2D_input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event_is_left_click(event):
		var main_node = $"/root/Main" # Note: There is no MainNode in tutorials
		if not is_instance_valid(main_node): # therefore, this action does not matter during tutorials
			return

		if main_node.allow_edge_selection:
			_on_edge_click()

func get_joint_end1():
	return joint_end1

func get_joint_end2():
	return joint_end2

# Intended to be used for Kruskal and Prim, to order edges
func _on_edge_click() -> void:
	var stored_data = get_node("/root/StoredData")
	stored_data.set("selected_edge", self)

func get_adt():
	return self.adt

func get_class() -> String:
	return "GraphEdge"

func as_string() -> String:
	return "Edge (" + str(joint_end1.get("index")) + "-" + str(joint_end2.get("index")) + ")"

func get_connecting_nodes() -> Array:
	return [joint_end1, joint_end2]

func set_selected() -> void:
	self.is_selected = true
	self.modulate = Color(1.0, 0.0, 0.0)

func set_weight_visible(visible_weight: bool) -> void:
	curr_label.visible = visible_weight

func is_not_selected() -> bool:
	return not self.is_selected

func set_is_highlighted(set_is_highlighted: bool) -> void:
	if set_is_highlighted:
		self.material = highlighted_material
	else:
		self.material = null
	
	# Used to set the edge as explored. An edge is considered explored when its two connecting nodes
func set_edge_transparency_as_explored() -> void:
	self.self_modulate = Color(1.0, 1.0, 1.0, 70/255.0)

func send_ship_from_nodeA_to_nodeB(nodeA: Node2D, nodeB: Node2D) -> void:
	# turn on animation to send the ship from nodeA to nodeB
	ship_path_follow.unit_offset = 0

	var path = ship_path.curve
	path.clear_points()
	path.add_point(nodeA.global_position)
	path.add_point(nodeB.global_position)
	var ship_travel_animation = ship_animation_player.get_animation("ShipTravel")
	ship_travel_animation.loop = false
	ship_animation_player.play("ShipTravel")
	# When the animation finishes, show the station at node B
	yield(ship_travel_animation, "animation_finished")
	notify_node_to_play_station_animation(nodeB)


func edge_connects_nodes_u_and_v(u: Node, v: Node) -> bool:
	if (joint_end1 == u and joint_end2 == v) or (joint_end1 == v and joint_end2 == u):
		return true
	return false

#func _on_ShipAnimationPlayer_animation_finished(anim_name: String) -> void:
#	notify_node_to_play_station_animation()

# Once the ship arrives at node B, we want to notify the node to play its animation
# of the station being built and the ship being flying around it
func notify_node_to_play_station_animation(input_node) -> void:
	if input_node and input_node.get_class() == "GraphNode":
		input_node.on_ship_arrived()
