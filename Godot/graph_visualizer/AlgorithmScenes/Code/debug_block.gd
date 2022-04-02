extends ScrollContainer
class_name DebugBlock

var variables : Dictionary = {}
var label_template : PackedScene = preload("res://AlgorithmScenes/Code/variable_in_heap_template.tscn") as PackedScene
onready var lines_container: VBoxContainer = $LinesContainer

func _ready():
	StoredData.heap = self

func add_variable(var_name, var_data):
	variables[var_name] = var_data
	var new_label = label_template.instance()
	new_label.text = str(var_name + " : " + str(var_data))
	lines_container.add_child(new_label)
	
