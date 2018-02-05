extends Node2D

onready var collision1 = get_node("collision1")
onready var collision2 = get_node("collision2")

onready var timer = get_node("Timer")

var opening_1
var opening_2

func open_1():
	collision1.set_layer_mask_bit(0,false)
	opening_1 = false

func open_2():
	collision2.set_layer_mask_bit(0,false)
	opening_2 = false
	
func reset():
	collision1.set_layer_mask_bit(0,true)
	collision2.set_layer_mask_bit(0,true)
	opening_1 = false
	opening_2 = false

#Signals from robot sensors
func _on_collision1_robot_entered():
	if !opening_1:
		opening_1 = true
		delay_call("open_1", 0.25)

func _on_collision2_robot_entered():
	if !opening_2:
		opening_2 = true
		delay_call("open_2", 0.25)

func _on_defense_boundary_robot_entered():
	pass

func _on_defense_boundary_robot_exited():
	pass

func delay_call(function, time):
	timer.set_wait_time(time)
	timer.connect("timeout", self, function, [], timer.CONNECT_ONESHOT)
	timer.start()