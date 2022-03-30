extends Resource
class_name EdgeCrossingsMinimization
# Static class for edge crossings minimization using a elastic force simulation
# algorithm

func get_positions_of_nodes_with_edges(
	graphs_positions: Array, 
	adj_matrix: Array
):
	var pos1 : Vector2 = Vector2.ZERO
	var pos2 : Vector2 = Vector2.ZERO
	var positions_of_nodes_with_edges : Array = []
	for i in range(adj_matrix.size()):
		for j in range(adj_matrix[i].size()):
			if (adj_matrix[i][j] > 0):
				pos1 = graphs_positions[i]
				pos2 = graphs_positions[j]
				positions_of_nodes_with_edges.append( [pos1, pos2] )

	return positions_of_nodes_with_edges


# To determine whether two vectors intersect
func ccw(A : Vector2, B: Vector2, C: Vector2):
	return (C.y-A.y) * (B.x-A.x) > (B.y-A.y) * (C.x-A.x)


# Return true if line segments AB and CD intersect
func intersect(A : Vector2, B: Vector2, C: Vector2, D: Vector2):
	return ccw(A, C, D) != ccw(B, C, D) && ccw(A, B, C) != ccw(A, B, D)


func get_edge_crossings(
	graphs_positions: Array, 
	adj_matrix: Array
):
	var nodes_positions = get_positions_of_nodes_with_edges(graphs_positions, adj_matrix)
	var edge_crossings = []
	for seg1 in nodes_positions:
		for seg2 in nodes_positions:
			if seg1 != seg2 && intersect(seg1[0], seg1[1], seg2[0], seg2[1]):
				edge_crossings += 1

				
				

	return edge_crossings
				

func update_graphs_positions(
	graphs_positions: Array, 
	adj_matrix: Array
):
	pass
