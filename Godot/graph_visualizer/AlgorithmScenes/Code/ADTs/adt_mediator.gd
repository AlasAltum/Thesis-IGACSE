class_name ADTMediator
extends Resource

# Clas made to store all data regarding the model so it is in only one place
# This makes sure the StoredData Singleton, DebugBlock and ADTShower
# have only one single source of truth

var adt_shower: ADTShower
var debug_block: DebugBlock
var data : Array = []  # Array of ADTVector <ADT, int, String>
var selected_index = 0

# Called when the node enters the scene tree for the first time.
func _init(_adt_shower: ADTShower,  _debug_block: DebugBlock) -> void:
	adt_shower = _adt_shower
	debug_block = _debug_block


func update_models():
	adt_shower.update_model(data)
	debug_block.update_model(data)

func update_views():
	adt_shower.update_views(selected_index)
	debug_block.update_views(selected_index)

func update():
	update_models()
	update_views()

func has_variable(var_name: String):
	for adt_vector in data:
		if adt_vector.name == var_name:
			return true
	return false

func erase_variable_by_name(var_name: String):
	for adt_vector in data:
		if adt_vector.name == var_name:
			# Consider current_selected_index and current_adt
			if data.find(adt_vector, 0) == selected_index:
				self.selected_index = 0  # Reset index

			data.erase(adt_vector)
			break

	update()


func add_or_update_variable(var_name: String, _data: ADT) -> void:
	# TODO: Consider what to do with selected index
	if not has_variable(var_name):
		var new_row = ADTVector.new(_data, self.data.size(), var_name)
		self.data.append(new_row)
	else:
		update_variable(var_name, _data)

	update()


func update_variable(var_name: String, _data: ADT) -> void:
	for adt_vector in data:
		if adt_vector.name == var_name:
			adt_vector.data = _data  # Modify variable stored in data

