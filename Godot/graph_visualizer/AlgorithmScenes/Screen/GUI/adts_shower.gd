class_name ADTShower
extends PanelContainer

# Displays a Window Dialog that shows a visual representation
# of each variable in the stack 
# This class may be a: QueueRepresentation, StackRepresentation
var current_adt: ADTRepresentation
var stored_adts: Array = []
var name_to_representation: Dictionary = {}
var selected_variable_index: int = 0
var debug_block: DebugBlock

onready var variable_name_label: Label = $VBoxContainer/VarNameLabel


func _ready() -> void:
	StoredData.adt_shower = self
	debug_block = StoredData.debug_block

#func _on_ADTStructureButton_pressed() -> void:
#	self.popup()

func set_name_of_label(var_name: String):
	variable_name_label.text = "Current variable: " + var_name

func _input(event):
	if event.is_action_pressed("left"):
		_on_LeftButton_pressed()
	elif event.is_action_pressed("right"):
		_on_RightButton_pressed()


func hide_current_representatation():
	if current_adt and is_instance_valid(current_adt):
		current_adt.visible = false  # make the previous adt invisible

# This method assumes the selected variable index was changed previously
func _update_shown_adt_after_index_change():
	hide_current_representatation()
	current_adt = stored_adts[self.selected_variable_index]

	if current_adt:
		# TODO: BUG with selected variable index after u is created
		debug_block.change_focus_of_label(self.selected_variable_index)
		set_name_of_label(debug_block.map_int_to_name[selected_variable_index])
		current_adt.visible = true  # make the previous adt invisible

func _on_LeftButton_pressed() -> void:
	_on_variable_index_down()

func _on_variable_index_down():
	if debug_block.labels.size() > 1:
		self.selected_variable_index = (self.selected_variable_index - 1) % debug_block.labels.size()
		# Since modulo % may render negative results, use an if to have circularity
		if self.selected_variable_index == -1:
			self.selected_variable_index = debug_block.labels.size() - 1
		_update_shown_adt_after_index_change()


func _on_RightButton_pressed() -> void:
	_on_variable_index_up()


func _on_variable_index_up():
	if debug_block.labels.size() > 1:
		self.selected_variable_index = (self.selected_variable_index + 1) % debug_block.labels.size()
		_update_shown_adt_after_index_change()

func update_representation(var_name, data):
	if StoredData.has_variable(var_name):
		self.erase_representation(var_name)
	self.add_representation(var_name, data)

# Create a new representation given a variable name and new data
func add_representation(var_name, data) -> void:
	# One of: NodeRepresentation, QueueRepresentation, StackRepresentation 
	var representation: ADTRepresentation = data.create_representation()
	# Position may change according to the scene. Each ADT should have
	# a initial position method to set it.
	representation.position = representation.get_initial_position()
	# representation.set_properties() # if we want additional configuration	
	stored_adts.append(representation)
	name_to_representation[var_name] = representation
	$VBoxContainer/Container.add_child(representation)
	representation.visible = false

#   TODO: Check if this is a good option
#	# Show the new added representation
#	self.selected_variable_index = stored_adts.find_last(representation)
#
#	if self.stored_adts.size() > 1:
#		call_deferred("_update_shown_adt_after_index_change")
#		representation.visible = true
#		self.current_adt = representation



func erase_representation(var_name) -> void:
	# TODO: if current representation is this, change index
	# and check visibility
	var adt_representation: ADTRepresentation = name_to_representation[var_name]
	stored_adts.erase(adt_representation)
	name_to_representation.erase(var_name)
	adt_representation.queue_free()

 
## Add Node to ADT representation
#func _add_node(node: AGraphNode) -> void:
#	stored_adts.append(node)
#	current_adt._add_node(node)


## Remove Node from ADT representation
#func _remove_node(node: AGraphNode) -> void:
#	stored_adts.erase(node)
#	current_adt._remove_node(node)


