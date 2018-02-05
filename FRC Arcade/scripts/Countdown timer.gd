extends Label

export(float) var endgame_time
export(Color) var endgame_color

onready var timer = get_node("Timer")

signal end

var is_endgame_color = false

func _ready():
	pass

func _process(delta):
	set_text(String(int(timer.get_time_left())))
	#print(timer.get_time_left())
	if timer.get_time_left() < endgame_time && !is_endgame_color:
		set("custom_colors/font_color", endgame_color)
	if timer.get_time_left() <= 0 :
		timer.stop()
		set_process(false)
		emit_signal("end")


func start():
	timer.start()
	set_process(true)
