class_name ADTShower
extends PanelContainer

# Displays a Window Dialog that shows a visual representation
# of each variable in the stack 
# This class may be a: QueueRepresentation, StackRepresentation
var current_adt: ADTRepresentation
var stored_adt_reps: Array = []
var name_to_representation: Dictionary = {}

onready var variable_name_label: Label = $VBoxContainer/VarNameLabel

signal _on_variable_index_up  # Signal emitted when pressing up and moving the variable
signal _on_variable_index_down # Signal emitted when pressing down and moving the variable

func _ready() -> void:
	StoredData.adt_mediator.adt_shower = self
	StoredData.adt_mediator.connect("_on_variable_index_up", StoredData.adt_mediator, "_on_variable_index_up")
	self.connect("_on_variable_index_down", StoredData.adt_mediator, "_on_variable_index_down")


func set_name_of_label(var_name: String):
	variable_name_label.text = "Current variable: " + var_name

func _input(event):
	if event.is_action_pressed("up"):
		_on_UpButton_pressed()
	elif event.is_action_pressed("down"):
		_on_DownButton_pressed()

func _on_UpButton_pressed() -> void:
	emit_signal("_on_variable_index_up")

func _on_DownButton_pressed() -> void:
	emit_signal("_on_variable_index_down")

func clear_current_models():
	for adt_rep in stored_adt_reps:
		remove_child(adt_rep)
	stored_adt_reps.clear()

func update_models(data: Array) -> void:
	clear_current_models()
	# Data is an array of ADTVectors
	for adt_vector in data:
		var adt_representation = adt_vector.get_representation()
		stored_adt_reps.append(adt_representation)
		add_child(adt_representation)

func update_views(selected_index: int) -> void:
	#  make the previous adt representation invisible
	if current_adt and is_instance_valid(current_adt):
		current_adt.visible = false
	# Show a new representation
	current_adt = stored_adt_reps[selected_index]
	if current_adt:
		# TODO: BUG with selected variable index after u is created
		current_adt.visible = true  # make the previous adt invisible


