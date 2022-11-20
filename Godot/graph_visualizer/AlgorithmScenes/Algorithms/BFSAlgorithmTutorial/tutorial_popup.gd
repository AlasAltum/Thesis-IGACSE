class_name TutorialPopup
extends AcceptDialog
# The user may not hide this popup immediatly,
# only X seconds after it has appeared


export var time_before_close: float = 2.3
var accept_ok_timer: Timer
var is_waiting_timer: bool = true
var ok_button: Button

func _ready():
	accept_ok_timer = Timer.new()
	self.add_child(accept_ok_timer)
	ok_button = get_ok()
	ok_button.disabled = true
	self.connect("about_to_show", self, "_on_show")
	self.connect("confirmed", self, "_on_ok_button_pressed")
	var close_button : TextureButton = get_close_button()
	close_button.visible = false

# After popup is shown, start timer. 
func _on_show():
	accept_ok_timer.paused = false
	accept_ok_timer.start(time_before_close)
	accept_ok_timer.connect("timeout", self, "_on_ok_timer_timeout")

func _process(_delta):
	print(accept_ok_timer.time_left)

# Ok can only be pressed after 
func _on_ok_button_pressed():
	if not is_waiting_timer:
		self.hide()


func _on_ok_timer_timeout():
	is_waiting_timer = false
	ok_button.disabled = false
