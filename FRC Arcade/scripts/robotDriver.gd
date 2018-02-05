extends RigidBody2D

export(String) var input_prefix

#driving settings
export(float) var linImpulse
export(float) var angImpulse

#settings for driving with joystick
export(bool) var use_joystick
export(float) var deadzone

#speed to fire balls at
export(float) var fire_speed
#how far in front of the robot to start the fired balls
export(float) var fire_offset
#delay before another ball can be picked up
export(float) var reload_delay
#timer to reload a new ball
var reload_timer = 0
#whether the bot is crossing a defense
var crossing_defense = false
#which side of the defense it was on when it entered
var right_of_defense = true

var last_defense
#centerline of defenses
export(float) var left_defense_center
export(float) var right_defense_center

#how far the bot has to go to exit or succeed.
export(float) var defense_judgement_dist

export(NodePath) var balls_path


#the collider of the ball pickup
onready var ball_pickup = get_node("ball pickup").get_shape()
onready var sample_player = get_node("sample player")
onready var motor_noise = get_node("motor sounds")
#whether the robot has a ball
var has_ball = true
onready var bot_ball = get_node("RobotBall")

#the preloaded robot ball
var ball_preload = preload("res://Scenes/Robot Ball.tscn")
#the preloaded physics ball
var normal_ball_preload = preload("res://Scenes/Ball.tscn")

#where to put balls
onready var balls_node = get_node(balls_path)
onready var spray = get_node("shoot spray")

func _ready():
	# Called every time the node is added to the scene.
	#set up the collision monitor
	set_contact_monitor(true)
	set_max_contacts_reported(1000)

func _fixed_process(delta):
	#increment ball timer
	reload_timer += delta
	
	#get the orientation of the robot
	var direction = get_global_transform().get_rotation()
	
	#read the inputs
	var input = get_inputs()

	#make noises
	motor_noise.call("set_speed", input.y)
	
	#calculate the force vector
	var force_vec = Vector2(0,1).rotated(direction) * input.y * linImpulse
	var ang_force = input.x * angImpulse
	
	#add the forces
	apply_impulse(Vector2(), force_vec * delta)
	
	var angVel = get_angular_velocity()
	set_angular_velocity(angVel + ang_force * delta)
	
	#check if the bot is in the defenses
	if abs(get_global_pos().x - left_defense_center) < defense_judgement_dist or abs(get_global_pos().x - right_defense_center) < defense_judgement_dist:
		if !crossing_defense:
			crossing_defense = true
			right_of_defense = get_right_of_defense()
	elif crossing_defense:
		crossing_defense = false
		if get_right_of_defense() != right_of_defense:
			#print that it's crossed and reset it
			print("Crossed defenses")
			print(last_defense)
			if last_defense != null:
				if last_defense.is_in_group("resettable"):
					last_defense.call("reset")
				var defense_container = last_defense.get_node("..")
				defense_container.call("damage")
			else:
				print("Error - no defense found!")
			#do other stuff
			
		else:
			print("Failed to cross defenses")
			
	

#check if the bot is to the left or right of the closest defense
func get_right_of_defense():
	#if the bot is at the left defenses
	if abs(get_global_pos().x - left_defense_center) < abs(get_global_pos().x - right_defense_center):
		return get_global_pos().x > left_defense_center
	else:
		return get_global_pos().x > right_defense_center

func get_inputs():
	if use_joystick:
		return Vector2(get_joy_input(0,0), get_joy_input(0,1))
	else:
		var out = Vector2()
		if Input.is_action_pressed(input_prefix + "up"):
			out.y -= 1
		if Input.is_action_pressed(input_prefix + "down"):
			out.y += 1
		if Input.is_action_pressed(input_prefix + "left"):
			out.x -= 1
		if Input.is_action_pressed(input_prefix + "right"):
			out.x += 1
		return out

func get_joy_input(var controller, var axis):
	var rawIn = Input.get_joy_axis(controller, axis)
	if abs(rawIn) < deadzone:
		return 0
	else:
		return rawIn

#Handles collisions and finds balls
func _on_Robot_body_enter_shape( body_id, body, body_shape, local_shape ):
	#check if the object is looking for the robot
	if body.is_in_group("robot sensor"):
		body.call("enter")
	#check if it's a defense
	if body.is_in_group("defense"):
		last_defense = body.get_node("..")
	#check if the robot can pick up a ball
	if get_shape(local_shape) == ball_pickup && body.is_in_group("balls"):
		ball_touched(body)

#pick up the ball if the robot doesn't already have one
func ball_touched(ball):
	print("Touched ball!")
	if !has_ball && reload_timer >= reload_delay:
		has_ball = true
		intake_ball(ball)

#intake a ball if it exists
func intake_ball(ball):
	ball.free()
	bot_ball = ball_preload.instance()
	add_child(bot_ball)

#called on input events like pressing the fire button (ui_accept)
func _input(event):
	if event.is_action_pressed(input_prefix + "A"):
		fire_button()
	

#called when the fire button is pressed
func fire_button():
	#if the player has a ball, fire it
	if has_ball:
		#set has_Ball to false
		has_ball = false
		#reset timer
		reload_timer = 0
		#make a poof of smoke
		spray.set_emitting(true)
		#make a thud noise
		sample_player.play("thud1")
		#get the position, direction, and velocity of the fired ball
		var ballPos = bot_ball.get_global_pos()
		var direction = get_global_transform().get_rotation()
		var fire_vel = Vector2(0,1).rotated(direction) * fire_speed
		ballPos += Vector2(0,1).rotated(direction) * fire_offset
		#remove the robot's ball
		bot_ball.free()
		#create a new ball and shoot it
		var new_ball = normal_ball_preload.instance()
		new_ball.set_global_pos(ballPos)
		new_ball.set_linear_velocity(fire_vel)
		balls_node.add_child(new_ball)
		new_ball.call("shoot_ball")

func _on_Robot_body_exit( body ):
	if body.is_in_group("robot sensor"):
		body.call("exit")

func set_active(active):
	#set up the function called every physics frame
	set_fixed_process(active)
	#process inputs like pressing the fire button
	set_process_input(active)
	if !active:
		motor_noise.stop_all()
