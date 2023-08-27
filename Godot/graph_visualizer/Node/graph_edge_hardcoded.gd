class_name GraphEdgeHardcoded
extends GraphEdge


var labels_and_positions_with_nodes_executions = 0

func _ready():
	self.z_index = -3
	set_process(false)
	line = $"Line2D";
	collision_line = $"Area2D/LineCollision";
	clickable_area = collision_line.shape
	ship_path = $"ShipPath";
	ship_path_follow = $"ShipPath/ShipPathFollow";
	ship_animation_player = $"ShipPath/ShipAnimationPlayer";
	shipSprite = $"ShipPath/ShipPathFollow/Sprite";
	# Get the node sfrom the node paths that are hardcoded from the scene and generate
	# an edge between these nodes 
	var node1 = get_node(node_a);
	var node2 = get_node(node_b);
	set_label_and_positions_with_nodes(node1, node2, "");


# Override so it works in tutorials
# Since the setting of labels can occur in the GraphManager and it assigns
# the node1 and node2 arguments, which are generated at runtime, we need to
# make sure this does not happen more than once for hardcoded cases.
# The node1 and node2 arguments are given in the 
# We prefer to set this using exports like the node1 and node2
func set_label_and_positions_with_nodes(node1: Node2D, node2: Node2D, label_text: String) -> void:
	if labels_and_positions_with_nodes_executions > 0:
		print("set_label_and_positions_with_nodes should not be called more than once");
		return
	
	.set_label_and_positions_with_nodes(node1, node2, label_text)
	labels_and_positions_with_nodes_executions += 1

