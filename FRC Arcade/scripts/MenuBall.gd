extends RigidBody2D

onready var particles = get_node("ParticleSpray")
onready var noises = get_node("SamplePlayer2D")

var can_explode = true

export(Vector2) var start_pos
export(float) var init_xvel
export(float) var init_yvel
export(float) var init_rand
export(float) var init_rot
export(float) var reset_y
export(float) var gravity

func _ready():
	#enable the fixedprocess
	set_fixed_process(true)
	#enable contact monitoring
	set_contact_monitor(true)
	set_max_contacts_reported(1)
	randomize()

func _fixed_process(delta):
	#add gravity
	apply_impulse(Vector2(), Vector2(0,gravity) * delta)
	
	#check for a collision
	if get_colliding_bodies().size() > 0 && can_explode:
		particles.set_emitting(true)
		random_sample()
		can_explode = false
	
	#check if a reset is needed
	if get_pos().y > reset_y:
		print("Reset ball")
		reset()

func random_sample():
	var rand = randi() % 3
	if rand == 0:
		noises.play("impact1")
	elif rand == 1:
		noises.play("impact2")
	elif rand == 2:
		noises.play("impact3")

func reset():
	#reset explody thing
	can_explode = true
	
	#calculate the initial velocity
	var vel = Vector2(init_xvel + rand_range(-init_rand,init_rand), init_yvel + rand_range(-init_rand,init_rand))
	
	#set position/velocity
	set_global_pos(start_pos)
	set_linear_velocity(vel)
	set_global_rot(0)
	set_angular_velocity(rand_range(-init_rot, init_rot))