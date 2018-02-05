extends Node2D

onready var collision = get_node("collision")
onready var timer = get_node("Timer")
onready var slope = get_node("Area2D")
export(float) var delay_time
export(float) var slope_strength

var opening = false

func _ready():
	slope.set_gravity(slope_strength)

func _on_left_sensor_robot_entered():
	set_grav_vec(Vector2(-1,0))

func _on_right_sensor_robot_entered():
	set_grav_vec(Vector2(1,0))

func set_grav_vec(vec):
	slope.set_gravity_vector(vec.rotated(get_global_rot()))

func _on_collision_robot_entered():
	if !opening:
		opening = true
		delay_call("open", delay_time)

func open():
	opening = false
	collision.set_layer_mask_bit(0, false)

func reset():
	collision.set_layer_mask_bit(0,true)

func delay_call(function, time):
	timer.set_wait_time(time)
	timer.connect("timeout", self, function, [], timer.CONNECT_ONESHOT)
	timer.start()