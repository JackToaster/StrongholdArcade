extends RigidBody2D

#the variables for launching the ball
export(float) var raising_time
export(float) var score_start_time
export(float) var score_end_time
export(float) var landing_time

export(String) var red_goal_groupname
export(String) var blue_goal_groupname

export(float) var lin_damp

export(float) var sound_min_velocity
export(float) var sound_volume
#the timer for the shot ball
var timer = 0

#whether the ball can enter the high and low goals
var can_enter_low = true
var can_enter_high = false

var is_flying = false

var freeing_object

onready var sprite = get_node("Sprite")
onready var trail = get_node("trail")
onready var ground_explosion = get_node("ground explosion")
onready var normal_explosion = get_node("normal explosion")
onready var sample_player = get_node("SamplePlayer2D")
onready var shadow = get_node("shadow")
onready var free_timer = get_node("free timer")

func _ready():
	set_fixed_process(false)
	set_contact_monitor(true)
	set_max_contacts_reported(100)

func shoot_ball():
	trail.set_emitting(true)
	is_flying = true
	shadow.call("set_flying", true)
	timer = 0
	set_linear_damp(-1)
	set_fixed_process(true)

#called when the ball is airborne
func _fixed_process(delta):
	timer += delta
	#determine if the ball is low enough for the low goal
	if timer < raising_time:
		can_enter_low = true
		can_enter_high = false
	elif timer < score_start_time:
		can_enter_low = false
		can_enter_high = false
	elif timer < score_end_time:
		can_enter_high = true
		can_enter_low = false
	elif timer < landing_time:
		can_enter_low = false
		can_enter_high = false
	else:
		set_flying_done()
		return
		
	set_colliders()

func set_flying_done():
	set_linear_damp(lin_damp)
	set_linear_velocity(0.5 * get_linear_velocity())
	is_flying = false
	shadow.call("set_flying", false)
	timer = 0
	reset_colliders()
	trail.set_emitting(false)
	ground_explosion.set_emitting(true)
	play_impact_sound()
	set_fixed_process(false)

func play_impact_sound():
	var rand = randi() % 3
	if rand == 0:
		sample_player.play("impact1")
	elif rand == 1:
		sample_player.play("impact2")
	elif rand == 2:
		sample_player.play("impact3")

#resets the colliders to the ground (haha) state
func reset_colliders():
	set_collision_mask_bits(true, true, true, false, true, true)
	set_ground_layer()

func set_ground_layer():
	set_layer_mask_bit(1,true)
	set_layer_mask_bit(8,false)
	set_z(2)

func set_air_layer():
	set_layer_mask_bit(1,false)
	set_layer_mask_bit(8,true)
	set_z(5)
#sets the collision bit mask of the six bits that matter
func set_collision_mask_bits(bit0, bit1, bit2, bit3, bit4, bit5):
	set_collision_mask_bit(0,bit0)
	set_collision_mask_bit(1,bit1)
	set_collision_mask_bit(2,bit2)
	set_collision_mask_bit(3,bit3)
	set_collision_mask_bit(4,bit4)
	set_collision_mask_bit(5,bit5)

#sets proper colliders based on height
func set_colliders():
	if can_enter_low:
		reset_colliders()
	elif can_enter_high:
		set_air_layer()
		set_collision_mask_bits(false, false, false, false, false, true)
	else:
		set_air_layer()
		set_collision_mask_bits(false, false, false, true, false, true)

func no_colliders():
	set_collision_mask_bits(false, false, false, false, false, false)

func _on_Ball_body_enter( body ):
	if body.is_in_group(red_goal_groupname) or body.is_in_group(blue_goal_groupname):
		body.call("goal", can_enter_high, self)
		sample_player.play("crash1")
	else:
		var body_vel = Vector2(0,0)
		if body.has_method("get_linear_velocity"):
			body_vel = body.get_linear_velocity()
		if (get_linear_velocity() - body_vel).length() > sound_min_velocity:
			play_impact_sound()
			normal_explosion.set_emitting(true)
		if is_flying && can_enter_low:
			set_flying_done()

func wait_free(freer):
	sprite.hide()
	shadow.hide()
	set_flying_done()
	no_colliders()
	set_linear_velocity(Vector2(0,0))
	free_timer.start()
	freeing_object = freer

func _on_free_timer_timeout():
	freeing_object.call("free_waiting_ball", self)
