class_name DebugBlock  # Also Heap
extends ScrollContainer

# Contains the variables displayed in the left panel of the screen

var focused_style: StyleBox = preload("res://AlgorithmScenes/Screen/DebugBlock/focus_line_stylebox.stylebox")
var focused_material: Material = preload("res://AlgorithmScenes/Screen/DebugBlock/debug_block_line_focus.material")
var unfocused_style: StyleBox = preload("res://AlgorithmScenes/Screen/DebugBlock/unfocus_line_stylebox.stylebox")
var label_template : PackedScene = preload("res://AlgorithmScenes/Code/variable_in_heap_template.tscn") as PackedScene
onready var lines_container: VBoxContainer = $LinesContainer

var mouse_inside_area: bool = false
var labels = {}  # Type<String, Label>
var map_inta_to_name = {} # Type<int, String>
var curr_label: Label
# We use labels[map_int_to_name[0]] to get the label object from an integer

func _ready():
	StoredData.debug_block = self

func has_variable(variable_name: String):
	return variable_name in self.labels


func update_data_with_dictionary(new_data: Dictionary):
	for variable in new_data:
		if not self.has_variable(variable):
			add_variable(variable, new_data[variable])
		else:
			set_data_to_label(
				labels[variable],
				variable,
				new_data[variable]
			)
	# There is a label that should be erased.
	# In this case, "u" should be erased, and there are more labels
	# than the new data that is being received
	if labels.size() > new_data.size() and "u" in labels:
		labels["u"].queue_free()
		labels.erase("u")

# Add a variable to the heap
func add_variable(var_name, var_data):
	var new_label : Label = self.label_template.instance() as Label
	set_data_to_label(new_label, var_name, var_data)
	lines_container.add_child(new_label)


func set_data_to_label(label: Label, var_name: String, var_data):
	label.name = str("heap_" + var_name)
	label.text = str(var_name + " : " + str(var_data.as_string()))
	self.labels[var_name] = label
	self.map_int_to_name[self.labels.size() - 1] = var_name
	label.add_to_group("heap_objects")
	label.clip_text = true


# Find label by name and set its data
func modify_variable(var_name, var_data):
	var label_to_update: Label = self.labels[var_name]
	set_data_to_label(label_to_update, var_name, var_data)

# This happens when a DraggedADT is brought to the heap
func _input(event):
	if mouse_inside_area and StoredData.dragging_adt and event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.pressed:
		StoredData._on_adt_drop_on_heap()

func _on_Area2D_mouse_entered():
	if StoredData.dragging_adt:
		mouse_inside_area = true
		StoredData.make_following_texture_opaque()


func _on_Area2D_mouse_exited():
	if StoredData.dragging_adt:
		mouse_inside_area = false
		StoredData.make_following_texture_transparent()

# This is done to focus the variable shown in the ADTShower
func change_focus_of_label(index: int):
	if curr_label and is_instance_valid(curr_label):
		curr_label.add_stylebox_override("normal", unfocused_style)
		curr_label.material = null

	if map_int_to_name.size() > 0 and labels.size() < index:
		curr_label = labels[map_int_to_name[index]]
		curr_label.add_stylebox_override("normal", focused_style)
		curr_label.material = focused_material
