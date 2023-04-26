class_name ADTShower
extends PanelContainer

# Displays a Window Dialog that shows a visual representation
# of each variable in the stack 
# This class may be a: QueueRepresentation, StackRepresentation
var current_adt: ADTRepresentation
var stored_adt_reps: Array = []  # Array<ADTRepresentation>
var name_to_representation: Dictionary = {}

onready var variable_name_label: Label = $VBoxContainer/VarNameLabel
onready var rep_container: Container = $VBoxContainer/Container

signal _on_variable_index_up  # Signal emitted when pressing up and moving the variable
signal _on_variable_index_down # Signal emitted when pressing down and moving the variable

func _ready() -> void:
	if StoredData.adt_mediator:
		StoredData.adt_mediator.adt_shower = self
		self.connect("_on_variable_index_up", StoredData.adt_mediator, "_on_variable_index_up")
		self.connect("_on_variable_index_down", StoredData.adt_mediator, "_on_variable_index_down")

func _input(event):
	if not StoredData.popup_captures_input:
		if event.is_action_pressed("KEY_up"):
			_on_UpButton_pressed()
		elif event.is_action_pressed("KEY_down"):
			_on_DownButton_pressed()

func _on_UpButton_pressed() -> void:
	emit_signal("_on_variable_index_up")

func _on_DownButton_pressed() -> void:
	emit_signal("_on_variable_index_down")

func clear_current_models():
	for adt_rep in stored_adt_reps:
		_remove_child(adt_rep)
	stored_adt_reps.clear()

func update_models(data: Array) -> void:
	clear_current_models()
	# Data is an array of ADTVector
	for adt_vector in data:
		var adt_representation = adt_vector.get_representation()
		if adt_representation:
			stored_adt_reps.append(adt_representation)
			_add_child(adt_representation)
			adt_representation.visible = false

func update_views(selected_index: int) -> void:
	#  make the previous adt representation invisible
	if current_adt and is_instance_valid(current_adt):
		current_adt.visible = false
	# Show a new representation
	current_adt = stored_adt_reps[selected_index]
	if current_adt:
		current_adt.visible = true  # make the previous adt invisible


func _remove_child(adt_representation):
	rep_container.remove_child(adt_representation)

func _add_child(adt_representation):
	rep_container.add_child(adt_representation)

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
#		if get_rect().has_point(get_global_mouse_position()):
#			print("mouse dentro")
		var graph_screen = StoredData.world_node
		var dragging_node = graph_screen.dragging_node
		var last_dragged_node_ref = StoredData.world_node.last_dragged_node_reference
		print("dropping node")
		if dragging_node and last_dragged_node_ref:
			if last_dragged_node_ref.get_class() == "AGraphNode":
				last_dragged_node_ref.get_added_to_focused_object_in_variables()
				# Free dragging node
				StoredData.world_node.mouse_has_entered_adt_shower = false
				StoredData.world_node.free_dragging_node()
#
#func _on_Area2D_mouse_entered():
#	print("entering mouse")
#	StoredData.world_node.mouse_has_entered_adt_shower = true
#
#func _on_Area2D_mouse_exited():
#	StoredData.world_node.mouse_has_entered_adt_shower = false
