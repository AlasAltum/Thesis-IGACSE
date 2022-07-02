class_name ADTMediator
extends Node2D

# Class made to store all data regarding the model so it is in only one place
# This makes sure the StoredData Singleton, DebugBlock and ADTShower
# have only one single source of truth

var adt_shower: ADTShower
var debug_block: DebugBlock
var data : Array = []  # Array of ADTVector <ADT, int, String>
var selected_index = 0


func _ready():
	StoredData.set_adt_mediator(self)
	# self.connect("on_correct_variable_creation", self, "_on_correct_variable_creation", [variable])

func update():
	update_models()
	update_views()

func update_models():
	adt_shower.update_models(data)
	debug_block.update_models(data)

func update_views():
	adt_shower.update_views(selected_index)
	debug_block.update_views(selected_index)
	
# Called when the node enters the scene tree for the first time.
func set_properties(_adt_shower,  _debug_block: DebugBlock) -> void:
	adt_shower = _adt_shower
	debug_block = _debug_block

# if the variable was correctly created from the ADT Grid
func _on_correct_variable_creation(variable_name: String):
	var generated_object: ADT = StoredData.dragged_adt.get_object()
	add_or_update_variable(variable_name, generated_object)
	# TODO: This was using GDScript	self.add_variable(variable_name, generated_object)
	StoredData.dragged_adt.queue_free()
	StoredData.dragged_adt = null


func has_variable(var_name: String):
	for adt_vector in data:
		if adt_vector.name == var_name:
			return true
	return false

func get_variable(var_name: String) -> ADTVector:
	for adt_vector in data:
		if adt_vector.name == var_name:
			return adt_vector.get_data()
	return null

func add_or_update_variable(var_name: String, _data: ADT) -> void:
	# TODO: Consider what to do with selected index
	var new_row: ADTVector
	if not has_variable(var_name):
		new_row = ADTVector.new(_data, self.data.size(), var_name)
		self.data.append(new_row)
	else:
		update_variable(var_name, _data)

	update()


func update_variable(var_name: String, _data: ADT, update_on_finish = false) -> void:
	for adt_vector in data:
		if adt_vector.name == var_name:
			adt_vector.data = _data  # Modify variable stored in data
	# Update is not necessary since it is made in the
	if update_on_finish:
		update()


func erase_variable_by_name(var_name: String):
	for adt_vector in data:
		if adt_vector.name == var_name:
			# Consider current_selected_index and current_adt
			# Reset index if selected index is going to be erased
			if data.find(adt_vector, 0) == selected_index:
				self.selected_index = 0

			data.erase(adt_vector)
			break

	update()

func add_node_to_adt(object_name: String, incoming_node):
	if has_variable(object_name):
		# Object may be a QueueADT, StackADT
		var object = get_variable(object_name)
		object.add_data(incoming_node)
		update()

#		add_or_update_variable(object_name, )
	# func add_node_to_adt(variable_name: String, node: AGraphNode):	
# 	if has_variable(variable_name):
# 		var var_data = heap_dictionary[variable_name]
# 		var_data.add_data(node)  # This method should be special for every ADT
# 		heap_dictionary[variable_name] = var_data
# 		_on_data_update()


func _on_variable_index_down():
	if data.size() > 0:
		if selected_index == 0:
			selected_index = data.size() - 1
		else:
			selected_index -= 1
		update_views()



