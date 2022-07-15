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

# Update models and views for both ADTShower and DebugBlock
func update() -> void:
	update_models()
	update_views()

func update_models():
	adt_shower.update_models(data)
	debug_block.update_models(data)

func update_views():
	adt_shower.update_views(selected_index)
	debug_block.update_views(selected_index)


func has_variable(var_name: String) -> bool:
	for adt_vector in data:
		if adt_vector.name == var_name:
			return true
	return false

func get_variable(var_name: String) -> ADT:
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
		_update_variable(var_name, _data)

	update()


func _update_variable(var_name: String, _data: ADT, update_on_finish = false) -> void:
	for adt_vector in data:
		if adt_vector.name == var_name:
			adt_vector.data = _data  # Modify variable stored in data
	# Update may not be necessary since it is made at the end
	if update_on_finish:
		update()


func erase_variable_by_name(var_name: String) -> void:
	for adt_vector in data:
		if adt_vector.name == var_name:
			# Reset index if selected index is going to be erased
			if data.find(adt_vector, 0) == selected_index:
				self.selected_index = 0

			data.erase(adt_vector)
			break

	update()


func add_node_to_adt(object_name: String, incoming_node):
	if has_variable(object_name):
		# Object may be a QueueADT, StackADT...
		var object = get_variable(object_name)
		object.add_data(incoming_node)
		update()

func take_top_from_adt(object_name: String):
	if has_variable(object_name):
		# Object may be a QueueADT, StackADT...
		var object = get_variable(object_name)
		var top_node = object.top()
		update()
		return top_node


### Signals ###

# if the variable was correctly created from the ADT Grid
func _on_correct_variable_creation(variable_name: String):
	var generated_object: ADT = StoredData.dragged_adt.get_object()
	add_or_update_variable(variable_name, generated_object)
	# TODO: This was using GDScript	self.add_variable(variable_name, generated_object)
	StoredData.dragged_adt.queue_free()
	StoredData.dragged_adt = null

# Change focus of variable in debug block and change representation
func _on_variable_index_up():
	if data.size() > 0:
		# Force circular behaviour
		if selected_index == 0:
			selected_index = data.size() - 1

		else:
			selected_index -= 1
		update_views()

# Change focus of variable in debug block and change representation
func _on_variable_index_down():
	if data.size() > 0:
		# Force circular behaviour
		if selected_index == data.size() - 1:
			selected_index = 0
		else:
			selected_index += 1
		update_views()



