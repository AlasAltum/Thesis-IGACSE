extends Node2D
class_name Edge

onready var curr_label = $Label
onready var line = $Line2D
var weight = 1


func set_label_and_positions(position1: Vector2, position2: Vector2, label: String):
	line.points = PoolVector2Array([position1, position2])
	curr_label.text = label

	curr_label.set_position( (position1 + position2) / 2 )
	self.set_z_index(-1)
