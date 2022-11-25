class_name TutorialPopup
extends AcceptDialog
# The user may not hide this popup immediatly,
# only X seconds after it has appeared


export var time_before_close: float = 2.3
var time_to_progress_factor: float
var progress_bar_until_ok: ProgressBar
var accept_ok_timer: Timer
var is_waiting_timer: bool = true
var ok_button: Button


func _initialize():
	accept_ok_timer = Timer.new()
	self.add_child(accept_ok_timer)
	ok_button = get_ok()
	ok_button.disabled = true
	var close_button : TextureButton = get_close_button()
	close_button.visible = false
	progress_bar_until_ok = $ProgressBarUntilOk
	progress_bar_until_ok.value = 0.0
	# Progress bar values are in the range [0, 100]
	# So we have to normalize that by the max waiting time
	# 2.3 => 100
	# x => y
	time_to_progress_factor = 100.0 / time_before_close
	self.connect("about_to_show", self, "_on_show")
	self.connect("confirmed", self, "_on_ok_button_pressed")


func _ready():
	_initialize()

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
