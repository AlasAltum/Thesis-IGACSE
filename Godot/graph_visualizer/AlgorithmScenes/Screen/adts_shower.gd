class_name ADTShower
extends WindowDialog

# Displays a Window Dialog that shows a visual representation
# of each variable in the stack 
# This class may be a: QueueRepresentation, StackRepresentation
var current_adt: ADTRepresentation
var stored_adts: Array = []
var selected_variable_index: int = 0
var debug_block: DebugBlock

onready var variable_name_label: Label = $VarNameLabel
onready var panel: Panel = $Panel


func _ready() -> void:
	StoredData.adt_shower = self
	debug_block = StoredData.debug_block

func _on_ADTStructureButton_pressed() -> void:
	self.popup()

func set_name_of_label(var_name: String):
	variable_name_label.text = "Current variable: " + var_name

func _update_shown_adt():
	if current_adt:
		current_adt.visible = false  # make the previous adt invisible
	current_adt = stored_adts[self.selected_variable_index]
	debug_block.change_focus_of_label(self.selected_variable_index)
	set_name_of_label(debug_block.map_int_to_name[selected_variable_index])
	if current_adt:
		current_adt.visible = true  # make the previous adt invisible


func _input(event):
	if event.is_action_pressed("left"):
		_on_LeftButton_pressed()
	elif event.is_action_pressed("right"):
		_on_RightButton_pressed()

func _on_LeftButton_pressed() -> void:
	_on_variable_index_down()


func _on_variable_index_down():
	if debug_block.labels.size() > 1:
		self.selected_variable_index = (self.selected_variable_index - 1) % debug_block.labels.size()
		# Since modulo % may render negative results, use an if to have circularity
		if self.selected_variable_index == -1:
			self.selected_variable_index = debug_block.labels.size() - 1
		_update_shown_adt()


func _on_RightButton_pressed() -> void:
	_on_variable_index_up()


func _on_variable_index_up():
	if debug_block.labels.size() > 1:
		self.selected_variable_index = (self.selected_variable_index + 1) % debug_block.labels.size()
		_update_shown_adt()

# Create a new representation given a variable name and new data
func add_representation(var_name, data) -> void:
	var representation: ADTRepresentation = data.representation
	representation.position = Vector2(270.0, 25.0)
	stored_adts.append(representation)
	panel.add_child(representation)
	representation.visible = true # TODO


func erase_representation(adt_representation: ADTRepresentation) -> void:
	stored_adts.erase(adt_representation)
	adt_representation.queue_free()


## Add Node to ADT representation
#func _add_node(node: AGraphNode) -> void:
#	stored_adts.append(node)
#	current_adt._add_node(node)


## Remove Node from ADT representation
#func _remove_node(node: AGraphNode) -> void:
#	stored_adts.erase(node)
#	current_adt._remove_node(node)


