extends TutorialPopup

const highlight_material = preload("res://Assets/custom_shaders/highlight_tutorial.tres")


func _ready():
	._initialize() # Super._initialize()
	ok_button.material = highlight_material  # our ok button should be highlighted

	self.connect("confirmed", self, "_on_TutorialVariablesPopup_confirmed")


# Once the user presses ok, the data structures panel is shown
func _on_TutorialVariablesPopup_confirmed():
	StoredData.animation_player.play_show_data_structures_panel()

# Flow: First, popup shows, activates _process, with each
# delta time, ProgressBar fills until its full. Then
# _on_ok_timer_timeout sets the Bar as full and disables processing.

# After popup is shown, start timer. 
func _on_show():
	accept_ok_timer.paused = false
	accept_ok_timer.start(time_before_close)
	accept_ok_timer.connect("timeout", self, "_on_ok_timer_timeout")
	set_process(true)


func _process(_delta: float):
	progress_bar_until_ok.value = 100.0 - accept_ok_timer.get_time_left() * time_to_progress_factor


func _on_ok_timer_timeout():
	is_waiting_timer = false
	ok_button.disabled = false
	set_process(false)
	progress_bar_until_ok.value = 100.0
