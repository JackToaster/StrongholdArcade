extends StaticBody2D

onready var half_field = get_node("../..")
onready var health_node = get_node("../health")
onready var ball_adder = get_node("../ball adder")

var health = 10

var is_red

func _ready():
	is_red = half_field.call("get_red")

func goal(high, ball):
	ball.call("wait_free", self)
	ball_adder.call("delay_add_ball")
	health -= 1
	set_health()
	if health == 0:
		get_node(Globals.get("game path")).call("castle_destroyed", is_red)
	get_node(Globals.get("game path")).call("ball_scored", high, is_red)

func set_health():
	if health >= 0 and health < 10:
		health_node.get_node(String(health)).hide()

func free_waiting_ball(ball):
	ball.queue_free()