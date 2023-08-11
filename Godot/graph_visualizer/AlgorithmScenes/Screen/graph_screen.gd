class_name GraphManager
extends Node2D

# Initializes the whole graph and keeps track of certain values important for the rendering,
# such as the edges positions, the weights of each edge, the nodes positions, etc.

export (String) var level_name = "BFS" # DFS, Kruskal, Prim...

const level_to_idx: Dictionary = {
	"BFS": 0, "DFS": 1, "Kruskal": 2, "Prim": 3
}

# We store the original textures in a separate array so we can reset the textures
# of the nodes when the level is restarted.
# We keep the textures in this class since there will be only a single instance of it
# Since textures use a lot of memory, we do not want to have multiple copies of them
const __planets_textures_original = [
	preload("res://Assets/textures/planets/level_planets/IceWorld.png"),
	preload("res://Assets/textures/planets/level_planets/LavaWorld.png"),
	preload("res://Assets/textures/planets/level_planets/MuddyTerranWet.png"),
	preload("res://Assets/textures/planets/level_planets/NoAtmosphere2.png"),
	preload("res://Assets/textures/planets/level_planets/NoAtmosphere.png"),
	preload("res://Assets/textures/planets/level_planets/PurpleTerranWet.png"),
	preload("res://Assets/textures/planets/level_planets/RedTerran.png"),
	preload("res://Assets/textures/planets/level_planets/WetPlanet.png")
]

var planets_textures = []
const station_explored_texture = preload("res://Assets/textures/station_explored.png")
const station_iterated_texture = preload("res://Assets/textures/station_complex.png")

## Graph related variables ##
var screen_size : Vector2
var left: int
var right: int
var up: int
var down: int
const circle = preload("res://Node/Node.tscn")
const edge = preload("res://Node/Edge.tscn")
var gameplay_menu_popup # : GameplayMenuPopup
var node_container_key_properties: Array

## Configurable elements ## 
export (float) var graph_density = 0.1
export (int) var graph_size = 5
export (float) var edge_max_weight = 5.0
export (bool) var is_weighted_graph = false
export (bool) var allow_edge_selection = false
export (bool) var returns_mst = false  # Kruskal and Prim return MST, this is to make sure the graph has more than n-1 edges
export (bool) var random_graph = true

# The copy moved by the player when dragging a node
var dragging_node: Sprite
var last_dragged_node_reference: KinematicBody2D # AGraphNode
var mouse_has_entered_adt_shower: bool = false

var start_os_datetime = {}
var start_time: int
var adt_mediator

var drop_dragging_node_timer: Timer


func _init():
	StoredData.reset_data()

func _ready():
	StoredData.world_node = self
	# Planets textures array is being modified each level when nodes are created
	# So by triggering this function at the beginning, we make sure that these textures
	# are available again so they can be used by the nodes
	reset_planets_textures()
	self.screen_size = get_viewport().get_visible_rect().size
	left = 100
	right = + int(self.screen_size.x)
	up = + int(self.screen_size.y)
	down = 100
	randomize()
	self.adt_mediator = $"%ADTMediator"
	node_container_key_properties = _init_node_container_key_properties()
	## Create Graph ##
	# create nodes and their connecting edges by initializing the matrix
	create_nodes_with_weights(graph_size)

	instance_nodes()  # Instances nodes objects as representation
	create_additional_edges_to_make_graph_connected()
	# This function may generate very large loops
#		if returns_mst:
#			create_additional_edges()

	drop_dragging_node_timer = Timer.new()
	drop_dragging_node_timer.autostart = false
	add_child(drop_dragging_node_timer)
	drop_dragging_node_timer.connect("timeout", self, "deferred_free_dragging_node")
	drop_dragging_node_timer.set_wait_time(0.2)

	instance_edges()  # To make sure the graph is connected
	if self.allow_edge_selection:
		for _edge in StoredData.edges:
			_edge.set_collision_box()  # TODO: error when reseting

	# send information to server
	send_data_level_transition()

	AudioPlayer.play_background_by_index(
		level_to_idx[level_name]
	)
	self.set_name("Main")
	$"%ReadyAnimation".play("OnStart")


func send_data_level_transition():
	var data_to_send = {"eventid": "", "deviceid": "", "intype": "", "mousepos": "", "keyboardpos": "", "timestamp": ""}
	data_to_send["eventid"] = str('Subscription: ') + str(OS.get_unique_id())
	data_to_send["deviceid"] = str(OS.get_unique_id())
	data_to_send["intype"] = "New level: " + level_name
	var ret = InputRecorder.SendRequest(data_to_send)


# We do not use 0.5 since that would make the node to be on the limit or frontier
# of our container, but we want to be completly inside of it
const RADIUS_THAT_FULLY_CONTAINS_TEXTURE_IN_CONTAINER = 0.45

# Return an array of positions, representing the four positions of the square
func _init_node_container_key_properties() -> Array:  # Array[Vector2]
	var node_container = $"%NodeContainer"
	# The container begins at the top left
	var upper_left = node_container.rect_global_position
	var center_position = upper_left + node_container.rect_size * 0.5
	var rect_size = node_container.rect_size * 0.45
	return [center_position, rect_size]

func _init_graph_matrix(num_nodes: int) -> void:
	StoredData.number_of_nodes = num_nodes
	for _i in range(num_nodes):
			StoredData.matrix.append([])

func _create_edge_between_nodes_with_max_weight(i: int, j: int) -> void:
	var weight = stepify( rand_range(1.0, edge_max_weight), 0.01)
	StoredData.matrix[i].append( [j, weight] )
	StoredData.matrix[j].append( [i, weight] )
	StoredData.number_of_edges += 1

# Node related functions
func create_nodes_with_weights(num_nodes: int):
	_init_graph_matrix(num_nodes)
	for i in range(num_nodes):
		for j in range(i + 1, num_nodes):
			# create an edge between node i and j with probability P = self.graph_density [0.0, 1.0]
			if randf() < self.graph_density and i != j:
				_create_edge_between_nodes_with_max_weight(i, j)


func instance_nodes():
	for _i in range(StoredData.matrix.size()):
		var curr_node = circle.instance()  # curr_node: AGraphNode
		$"%NodeContainer".add_child(curr_node)
		_on_node_instanced(curr_node)

# node: AGraphNode
func _on_node_instanced(node):
	# Set index and edges for node
	node.set_index(StoredData.nodes.size() - 1)  # This array will change after each instantation
	node.set_edges(StoredData.matrix[node.index])
	node.init_position_regarding_container(StoredData.number_of_nodes, node_container_key_properties)
	# Connect signals
	node.connect("node_add_to_object_request", NotificationManager, "_on_node_add_to_object")


func instance_edges():
	for i in range(StoredData.number_of_nodes):
		for pair in StoredData.matrix[i]:
			# pair = [node_number, weight]
			if i < pair[0]:
				instance_edge_between_nodes( i, pair[0], str(pair[1]) )

func instance_edge_between_nodes(node_idx1: int, node_idx2: int, label_with_weight: String):
	# Adds an edge with label between the nodes with the given indexes
	var curr_edge = edge.instance()
	# Set a name like Edge_0_to_2 to represent an edge connecting nodes 0 and 2
	curr_edge.set_name("Edge_%s_to_%s" % [str(node_idx1), str(node_idx2)])
	StoredData.edges.append(curr_edge)
	$"%EdgeContainer".add_child(curr_edge)
	curr_edge.set_label_and_positions_with_nodes(
		StoredData.nodes[node_idx1],  # pos node_idx1,
		StoredData.nodes[node_idx2],  # pos node_idx2,
		label_with_weight  # label
	)
	curr_edge.set_weight_visible(is_weighted_graph)  # invisible if BFS or DFS

func _create_random_partition_from_range(to: int, from: int) -> Array:
	var result = []
	for i in range(to, from):
		result.append(i)
	result.shuffle()
	return result

# For each node V_i, check if the graph is connected from that node.
# If not, find a node V_j whose index is not in the connected component of V_i
# If we make an edge between (V_i, V_j), then we make another connected component
# If we do that for each node, we surely will end up with a connected graph
func create_additional_edges_to_make_graph_connected():
	var random_partition = _create_random_partition_from_range(0, StoredData.number_of_nodes)
	for _i in random_partition:
		var node = StoredData.nodes[_i]  # AGraphNode
		if not _is_graph_connected():
			# We need to connect this node's tree to other tree
			var connected_nodes = _get_connected_nodes_for_node(node)
			var i = node.index  # _i may not be equal to i
			var j = _get_index_of_random_node_absent_in_array(connected_nodes)
			_create_edge_between_nodes_with_max_weight(i, j)


# utils for connected graphs ##
# Perform a BFS and get connected nodes
# node: AGraphNode
func _get_connected_nodes_for_node(node) -> Array:
	var queue: Queue = Queue.new()
	var visited_nodes: Array = []
	queue.push(node)
	visited_nodes.append(node)

	while queue.is_not_empty():
		var current_node = queue.pop()  # current_node: AGraphNode
		for neighbor_node in current_node.get_edges():
			# Select node Object, not pair <index, weight>
			neighbor_node = StoredData.nodes[neighbor_node[0]]
			if not neighbor_node in visited_nodes:
				queue.push(neighbor_node)
				visited_nodes.append(neighbor_node)

	return visited_nodes

# Get a node whose index is not in the given array
# So we know that if we have two separated trees, we can bind them
func _get_index_of_random_node_absent_in_array(connected_node_indexes: Array) -> int:
	# i.e connected_node_indexes = [1, 4, 6]
	# all_nodes = [1, 2, 3, 4, 5, 6]
	# so we could get a number like 2, 3 or 5
	var complement_of_connected_nodes = []
	for node_index in StoredData.nodes:
		if not node_index in connected_node_indexes:
			complement_of_connected_nodes.append(node_index)

	# Return a random index of all the nodes that are not in the array
	var generator = RandomNumberGenerator.new()
	var index_to_return = generator.randi_range(0, complement_of_connected_nodes.size() - 1)
	return complement_of_connected_nodes[index_to_return].index


func create_additional_edges() -> void:
	pass
	# According to the Handshaking lemma, the minimal number of edges is N-1 for a graph of size N
	# and for an undirected graph, the max number of edges is N*(N-1)/2.
	# We want our graph to have a number of edges between these two limits
	# The second one is guaranteed by our matrix data structure.
	
#	while StoredData.number_of_edges < StoredData.number_of_nodes:
#		var rng = RandomNumberGenerator.new()
#		var i = rng.randi_range(0, StoredData.number_of_nodes - 1)
#		var j = rng.randi_range(0, StoredData.number_of_nodes - 1)
#		while i == j and there_is_edge_an_between_nodes(i, j):
#			j = rng.randi_range(0, StoredData.number_of_nodes - 1)
#		if not there_is_edge_an_between_nodes(i, j):
#			_create_edge_between_nodes_with_max_weight(i, j)


func there_is_edge_an_between_nodes(i: int, j: int) -> bool:
	for pair in StoredData.matrix[i]:
		# pair has a struct: other_node, weight
		if pair[0] == j:
			return true
	return false


# If graph of size N is connected:
# after a BFS exploration starting from every node
# should find at least N 
func _is_graph_connected() -> bool:
	for node in StoredData.nodes:
		if _get_connected_nodes_for_node(node).size() != self.graph_size:
			return false
	return true


func _get_center_position_of_node_container() -> Vector2:
	var cont = $"%NodeContainer"
	return cont.rect_size * 0.5 


# The incoming sprite should come with a circle node and the label as child
func set_dragging_node(incoming_sprite: Sprite, real_node_reference: KinematicBody2D):
	dragging_node = incoming_sprite.duplicate()
	dragging_node.z_index = 5
	dragging_node.z_as_relative = false
	dragging_node.global_position = get_global_mouse_position()
	self.last_dragged_node_reference = real_node_reference
	# we use the control Canvas Layer to make sure the node is displayed
	# in front of the UI
#	$Control.add_child(dragging_node)
#	drop_dragging_node_timer.stop()

func start_release_dragging_node():
	drop_dragging_node_timer.start()

# We need to wait a bit before dropping the node
# Because it can cause a null pointer exception
func deferred_free_dragging_node():
	if StoredData.world_node and not StoredData.world_node.mouse_has_entered_adt_shower:
		call_deferred("free_dragging_node")

func free_dragging_node():
	if dragging_node != null:
		dragging_node.queue_free()
		dragging_node = null
		last_dragged_node_reference = null

func set_dragging_node_global_pos():
	if dragging_node != null:
		dragging_node.global_position = get_global_mouse_position()

func reset_planets_textures():
	self.planets_textures = __planets_textures_original.duplicate(true)

func go_to_random_level():
	var keys = Array(StoredData.remaining_levels_to_finish.keys())
	if keys.size() > 0:
		var random_index = randi() % keys.size()
		var random_level = keys[random_index]
		var random_level_scene_path: String = StoredData.remaining_levels_to_finish[random_level]
		StoredData.remaining_levels_to_finish.erase(level_name)
		NotificationManager.go_to_scene(random_level_scene_path)
		self.set_name("TempMain")
		call_deferred("queue_free")

func go_back_to_menu():
	AudioPlayer.stop_playing_music() # Whatever the music soundtrack playing, stop it when coming back to the menu
	self.set_name("TempMain")
	call_deferred("queue_free")
	NotificationManager.go_to_scene("res://GameFlow/MainMenu.tscn")

func get_class() -> String:
	return "GraphManager"

func assign_texture_randomly() -> bool:
	return true
