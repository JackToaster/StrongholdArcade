extends Node2D

onready var collision = get_node("collision")
onready var timer = get_node("Timer")

export(float) var delay_time

var opening = false

func _ready():
	pass

func reset():
	collision.set_layer_mask_bit(0,true)
	timer.stop()
	opening = false

func open():
	collision.set_layer_mask_bit(0,false)

func delay_call(function, time):
	timer.set_wait_time(time)
	timer.connect("timeout", self, function, [], timer.CONNECT_ONESHOT)
	timer.start()

func _on_collision_robot_entered():
	if !opening:
		opening = true
		delay_call("open", delay_time)
