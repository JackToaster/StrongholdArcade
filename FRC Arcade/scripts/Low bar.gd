extends Node2D

onready var bar = get_node("bar")
onready var timer = get_node("Timer")

export(float) var delay_time

var opening = false

func _ready():
	pass

func reset():
	bar.set_layer_mask_bit(0,true)
	timer.stop()
	opening = false

func open():
	bar.set_layer_mask_bit(0,false)
	
func _on_sensors_robot_entered():
	if !opening:
		opening = true
		delay_call("open", delay_time)

func delay_call(function, time):
	timer.set_wait_time(time)
	timer.connect("timeout", self, function, [], timer.CONNECT_ONESHOT)
	timer.start()


func _on_bar_robot_entered():
	delay_call("open", 0.1)
