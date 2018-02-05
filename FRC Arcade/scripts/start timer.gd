extends Label

onready var tint = get_node("screen tint")

onready var timer = get_node("Timer")
onready var tween = get_node("Tween")
onready var tween1 = get_node("Tween1")
signal game_start

var not_fading = true

func _ready():
	start()
	set_process(true)

func _process(delta):
	set_text(String(int(timer.get_time_left())))
	if timer.get_time_left() < 1 and not_fading:
		not_fading = false
		start_fade()
	if timer.get_time_left() <= 0:
		timer.stop()
		set_process(false)
		emit_signal("game_start")
		get_node("..").queue_free()

func start_fade():
	tween.set_tween_process_mode(1)
	tween.interpolate_property(self, "custom_colors/font_color", Color(1,1,1,1), Color(1,1,1,0), 0.5, 0, 0)
	tween1.interpolate_method(tint, "set_color", Color(0,0,0,0.75), Color(0,0,0,0), 0.5, 0, 0)
	tween.start()
	tween1.start()

func start():
	timer.start()

