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

