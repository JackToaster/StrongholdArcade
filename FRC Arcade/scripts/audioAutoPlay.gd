extends StreamPlayer

export(float) var volume_percent
export(float) var delay

onready var timer = get_node("StartTimer")

func _ready():
	set_volume(volume_percent / 100)
	if delay != 0:
		timer.set_wait_time(delay)
		timer.start()
	else:
		play()



func _on_StartTimer_timeout():
	play()
