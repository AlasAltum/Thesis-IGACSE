# class_name NotificationManager 
extends Node2D

## Code execution popups ##
var finished_popup : WindowDialog; 
var u_is_explored_popup : WindowDialog # = $UNodeIsExploredPopup
var adt_is_empty_popup : WindowDialog # = $QIsNotEmptyPopup
var add_node_popup : AddNodePopup 

## Continue conditions ##
var u_is_explored: bool = false
var adt_is_empty: bool = false
var hint_label


func reset_data():
	finished_popup = null
	u_is_explored_popup = null
	adt_is_empty_popup = null
	add_node_popup = null
	u_is_explored = false
	adt_is_empty = false

# func _ready():
# 	finished_popup = get_tree().get_node("root/BFSFinishedPopup")
# 	u_is_explored_popup = get_tree().get_node("root/UNodeIsExploredPopup")
# 	adt_is_empty_popup = get_tree().get_node("root/QIsNotEmptyPopup")
# 	add_node_popup = get_tree().get_node("root/AddNodePopup")

# node: AGraphNode
# Commented to avoid Ciclyc dependencies
func _on_node_add_to_object(node):
	add_node_popup.popup()
	add_node_popup.incoming_node = node

func _on_AllowGraphMovementButton_pressed():
	StoredData.set_status("DRAG")

func _on_SelectNodeButton_pressed():
	StoredData.set_status("SELECT")
	

# StoredData Autoload will trigger
# func on_code_finished_popup(_msg: String):
#	self.world_node.on_code_finished_popup(_msg)
func on_code_finished_popup(_msg: String) -> void:
	finished_popup.show()
#	return
## Node related functions ##

## Hint related methods ##
func set_hint_text(new_text: String) -> void:
	hint_label.bbcode_text = new_text
## Hint related methods ##

## BFS Finished Popup signals ##

func _on_ResetButton_pressed() -> void:
	StoredData.reset_data()
	self.reset_data()
	get_tree().reload_current_scene()

func _on_MenuButton_pressed() -> void:
	pass # TODO: Add Menu for different algorithms

## BFS Finished Popup signals ##

## U.is_explored() popup signals ##
# Show popup 
func ask_user_if_graph_node_is_explored(u, condition_value: bool):
	u_is_explored_popup.show()
	u_is_explored_popup.get_node("Explanation").text = (
		"Is the U node (" + str(u.index) + ") explored?"
	)
	 # This stablishes whether yes or no should be pressed
	self.u_is_explored = condition_value

func notify_u_is_explored_correct_answer():
	StoredData.u_is_explored_right_answer = true
	u_is_explored_popup.hide()
	# TODO: Add sound effect
	# TODO: Add visual effect

func notify_u_is_explored_wrong_answer():
	# Visual effect
	print($UNodeIsExploredPopup/ErrorNotification/AnimationPlayer)
	$UNodeIsExploredPopup/ErrorNotification/AnimationPlayer.stop()
	$UNodeIsExploredPopup/ErrorNotification/AnimationPlayer.play("message_modulation")
	# TODO: Add sound effect

func _on_YesButton_pressed() -> void:
	if self.u_is_explored:  # Expected answer
		# Close the popup
		notify_u_is_explored_correct_answer()
	else: # Wrong answer
		notify_u_is_explored_wrong_answer()


func _on_NoButton_pressed() -> void:
	if self.u_is_explored:  # Wrong answer
		notify_u_is_explored_wrong_answer()
	else:  # Expected answer
		# Close the popup
		notify_u_is_explored_correct_answer()

## U.is_explored() popup signals ##

## adt.is_not_empty() popup signals ##
func ask_user_if_adt_is_empty(is_adt_empty: bool):
	adt_is_empty_popup.show()
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
	# TODO: Visual effect
	$QIsNotEmptyPopup/ErrorNotification/AnimationPlayer.stop()
	$QIsNotEmptyPopup/ErrorNotification/AnimationPlayer.play("message_modulation")
	# TODO: Add sound effect
