extends SamplePlayer

export(float) var pitch_mult
export(float) var min_speed

export(float) var volume_linear
export(float) var volume_base

var speed = 1
var playing = false
var voice = 0
func _ready():
	pass

func set_speed(speed):
	var abs_speed = abs(speed)
	if abs_speed > min_speed:
		if !playing:
			playing = true
			voice = play("motor")
		set_pitch_and_volume(abs_speed)
	else:
		if playing:
			playing = false
			stop(voice)
			
func set_pitch_and_volume(speed):
	set_pitch_scale(voice, speed * pitch_mult)
	set_volume(voice,volume_base + volume_linear * speed)