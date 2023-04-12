# class_name NotificationManager
extends Node2D

## Code execution popups ##
var finished_popup : WindowDialog; 
var u_is_explored_popup : WindowDialog  # : $UNodeIsExploredPopup
var adt_is_empty_popup : WindowDialog  # : $ADTIsEmptyPopup
var add_node_popup : AddNodePopup 
var object_creation_popup: WindowDialog  # PopupForObjectCreation
var length_c_is_1_popup: WindowDialog  # : LengthCIsOnePopup
var _find_w_unequal_find_v_popup: WindowDialog  # : FindWUnequalFindVPopup
## Continue conditions ##
var u_is_explored: bool = false
var adt_is_empty: bool = false
var length_c_is_1: bool = false
var find_w_unequal_find_v: bool = false
var allow_code_advance : bool = true  # Only in tutorial level starts as false
# And this action is performed by the tutorial animation player
## 

var hint_label
onready var confirm_audio: AudioStreamPlayer = $ConfirmationAudioPlayer
onready var error_audio: AudioStreamPlayer = $ErrorAudioPlayer



func _on_variable_creation_popup(ADT_name: String):
	object_creation_popup.set_next_adt_name(ADT_name)
	object_creation_popup.popup()


const NOT_YET_SELECTED_VARIABLE = -1
# node: AGraphNode
# Commented to avoid Ciclyc dependencies
func _on_node_add_to_object(node):
	# Selected variable index has not been selected yet
	if StoredData.selected_variable_index == NOT_YET_SELECTED_VARIABLE:
		# TODO: Show popup with error message
		print("There is no selected variable in the variables stack!")

	# Add variable to object
	if StoredData.selected_variable_allows_object_adition(node):
		StoredData.add_node_to_adt(StoredData.get_selected_variable_name(), node)
		StoredData.emphasize_current_selected_variable()
		StoredData.remove_node_from_nodes_that_should_be_added_to_adt(node)

	else:
		# TODO: show popup with error message
		StoredData.emphasize_error_on_current_selected_variable()
		print("You cannot add this object to the current selected variable")

## Node related functions ##
func _on_AllowGraphMovementButton_pressed():
	StoredData.set_status("DRAG")

func _on_SelectNodeButton_pressed():
	StoredData.set_status("SELECT")

## Hint related methods ##
func set_hint_text(new_text: String) -> void:
	if self.hint_label and new_text and self.allow_code_advance:
		hint_label.bbcode_text = "[center]"
		hint_label.bbcode_text += new_text
## Hint related methods ##

## Finished Popup related methods ##
func show_code_finished_popup(_msg: String) -> void:
	InputRecorder.send_requests_with_records()
	if finished_popup:
		finished_popup.show()
	else:
		printerr("Notification Manager: No finished pop up found!")

## Audios
func play_confirmation_audio():
	confirm_audio.play()

func play_error_audio():
	error_audio.play()


# Called from finished code popup, when finishing an algorithm
func reset_game():
	StoredData.reset_data()
	self.reset_data()
	get_tree().reload_current_scene()

## BFS Finished Popup signals ##

## U.is_explored() popup signals ##
# Show popup 
func ask_user_if_graph_node_is_explored_bfs(u, condition_value: bool):
	u_is_explored_popup.popup()
	u_is_explored_popup.get_node("Explanation").text = (
		"Has the U node (" + str(u.index) + ") been marked as explored or iterated?"
	)
	 # This stablishes whether yes or no should be pressed
	self.u_is_explored = condition_value

func ask_user_if_graph_node_is_explored_dfs(u, condition_value: bool):
	u_is_explored_popup.popup()
	u_is_explored_popup.get_node("Explanation").text = (
		"Has the V node (" + str(u.index) + ") been marked as explored or iterated?"
	)
	 # This stablishes whether yes or no should be pressed
	self.u_is_explored = condition_value

func notify_u_is_explored_correct_answer():
	StoredData.v_is_explored_right_answer = true
	u_is_explored_popup.hide()
	# TODO: Add visual effect

func notify_u_is_explored_wrong_answer():
	u_is_explored_popup.notify_u_is_explored_wrong_answer()
	NotificationManager.play_error_audio()

func _on_YesButton_pressed() -> void:
	if self.u_is_explored:  # Expected answer
		notify_u_is_explored_correct_answer()
	else: # Wrong answer
		notify_u_is_explored_wrong_answer()


func _on_NoButton_pressed() -> void:
	if self.u_is_explored:  # Wrong answer
		notify_u_is_explored_wrong_answer()
	else:  # Expected answer
		notify_u_is_explored_correct_answer()

## U.is_explored() popup signals ##

## adt.is_not_empty() popup signals ##
func ask_user_if_adt_is_empty(is_adt_empty: bool):
	adt_is_empty_popup.popup()  # ADTIsEmptyPopup.popup()
	 # This stablishes whether yes or no should be pressed
	self.adt_is_empty = is_adt_empty

func _on_adt_is_empty_YesButton_pressed() -> void:
	if self.adt_is_empty:  # Wrong
		self.notify_adt_is_empty_wrong_answer()
	else:  # Right!
		self.notify_adt_is_empty_correct_answer()

func _on_adt_is_empty_NoButton_pressed() -> void:
	# if q is empty, expected answer is yes
	if self.adt_is_empty:
		self.notify_adt_is_empty_correct_answer()
	else:  # Wrong
		self.notify_adt_is_empty_wrong_answer()

func notify_adt_is_empty_correct_answer():
	StoredData.adt_is_empty_right_answer = true
	adt_is_empty_popup.hide()

func notify_adt_is_empty_wrong_answer():
	adt_is_empty_popup.play_wrong_animation()
#	$ADTIsNotEmptyPopup/ErrorNotification/AnimationPlayer.play("message_modulation")
	NotificationManager.play_error_audio()

## adt.is_not_empty() popup signals ##

## Length C is 1 popup signals ##
func ask_user_if_lenth_c_is_1(_length_c_is_1: bool) -> void:
	if length_c_is_1_popup:
		length_c_is_1_popup.show()
		self.length_c_is_1 = _length_c_is_1
	else:
		printerr("Notification Manager Error: length c is 1 popup not detected")

func _on_YesButton_length_c_is_1_popup_pressed():
	if self.length_c_is_1:  # Right!
		self.notify_length_c_is_one_correct_answer()
	else:  # Wrong!
		self.notify_length_c_is_one_wrong_answer()

func _on_NoButton_length_c_is_1_popup_pressed():
	if self.length_c_is_1:  # Wrong
		self.notify_length_c_is_one_wrong_answer()
	else:  # Right
		self.notify_length_c_is_one_correct_answer()

func notify_length_c_is_one_correct_answer():
	StoredData.length_c_is_one_correct_answer = true
	if length_c_is_1_popup:
		length_c_is_1_popup.hide()

func notify_length_c_is_one_wrong_answer():
	# TODO: Visual effect
	if length_c_is_1_popup:
		length_c_is_1_popup.play_wrong_animation()
## Length C is 1 popup signals ##

## if _find_w_unequal_find_v popup signals ##
func ask_user_if_find_w_unequal_find_v(_find_w_unequal_find_v: bool) -> void:
	if _find_w_unequal_find_v_popup:
		_find_w_unequal_find_v_popup.show()
		self.find_w_unequal_find_v = _find_w_unequal_find_v
	else:
		printerr("Notification Manager Error: Find w unequal find v")

func _on_YesButton_find_w_unequal_find_v_pressed():
	if self.find_w_unequal_find_v:  # Right!
		self.notify_find_w_unequal_find_v_correct_answer()
	else:  # Wrong!
		self.notify_find_w_unequal_find_v_wrong_answer()

func _on_NoButton_find_w_unequal_find_v_pressed():
	if self.find_w_unequal_find_v:  # Wrong
		self.notify_find_w_unequal_find_v_wrong_answer()
	else:  # Right
		self.notify_find_w_unequal_find_v_correct_answer()
		
func notify_find_w_unequal_find_v_correct_answer():
	StoredData.find_w_unequal_find_v_correct_answer = true
	if _find_w_unequal_find_v_popup:
		_find_w_unequal_find_v_popup.hide()

func notify_find_w_unequal_find_v_wrong_answer():
	# TODO: Visual effect
	if _find_w_unequal_find_v_popup:
		_find_w_unequal_find_v_popup.play_wrong_animation()
## if _find_w_unequal_find_v popup signals ##


func reset_data():
	self.finished_popup = null
	self.u_is_explored_popup = null
	self.adt_is_empty_popup = null
	self.add_node_popup = null
	self.object_creation_popup = null
	self.length_c_is_1_popup = null
	self._find_w_unequal_find_v_popup = null
	## Continue conditions ##
	self.u_is_explored = false
	self.adt_is_empty = false
	self.length_c_is_1 = false
	self.find_w_unequal_find_v = false
	self.allow_code_advance = true
	self.hint_label = null
