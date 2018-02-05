extends Node2D

export(float) var add_delay
export(float) var ball_vel
export(float) var ball_rand_x
export(float) var ball_rand_y

onready var preload_ball = preload("res://Scenes/Ball.tscn")

var queue = []

func _ready():
	set_process(true)

func _process(delta):
	var remove = -1
	for i in range(0, queue.size()):
		queue[i] -= delta
		if queue[i] <= 0:
			add_ball()
			remove = i
	if remove != -1:
		queue.remove(remove)

func delay_add_ball():
	queue.append(add_delay)

func add_ball():
	var ball = preload_ball.instance()
	var linear_vel = Vector2(ball_vel,0) + Vector2(rand_range(-ball_rand_x, ball_rand_x), rand_range(-ball_rand_y, ball_rand_y))
	linear_vel = linear_vel.rotated(get_global_rot())
	ball.set_linear_velocity(linear_vel)
	add_child(ball)
