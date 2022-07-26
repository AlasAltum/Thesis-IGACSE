class_name EdgeADT
extends ADT
# Edge ADT to be stored in variables


var edge  # GraphEdge.cs
const edge_rep_prefab = preload("res://Node/EdgeRepresentation.tscn")


func _init(_edge):
	edge = _edge
	self.representation = edge_rep_prefab.instance()
	self.representation.edge = _edge


static func get_type() -> String:
	return "Edge"

func as_string() -> String:
	return edge.as_string()

func get_object(): # -> ADT:
	return self

func get_representation(): # -> ADTRepresentation:
	return self.representation

func get_connecting_nodes():
	return edge.get_connecting_nodes()

func get_edge():
	return edge
