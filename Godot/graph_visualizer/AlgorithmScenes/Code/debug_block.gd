extends ScrollContainer
class_name DebugBlock  # Also Heap

var label_template : PackedScene = preload("res://AlgorithmScenes/Code/variable_in_heap_template.tscn") as PackedScene
onready var lines_container: VBoxContainer = $LinesContainer
var mouse_inside_area: bool = false
var labels = {}  # Type<String, Label>

func _ready():
	StoredData.heap = self

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
	# There is a label that should be erased
	if labels.size() > new_data.size():
		for _label_name in labels:
			if not _label_name in new_data:
				labels[_label_name].queue_free()

func add_variable(var_name, var_data):
	var new_label : Label = self.label_template.instance() as Label
	set_data_to_label(new_label, var_name, var_data)
	lines_container.add_child(new_label)

func set_data_to_label(label: Label, var_name: String, var_data):
	label.name = str("heap_" + var_name)
	label.text = str(var_name + " : " + str(var_data.as_string()))
	self.labels[var_name] = label
	label.add_to_group("heap_objects")
	label.clip_text = true


func modify_variable(var_name, var_data):
	# Find label by name
	var label_to_update: Label = self.labels[var_name]
	set_data_to_label(label_to_update, var_name, var_data)

## This happens when a DraggedADT is brought to the heap
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

