extends Sprite

export(float) var normal_offset

export(float) var height_mult
export(float) var time_to_highest

var timer = 0
var flying = false

onready var parent = get_node("..")

func _ready():
	set_process(true)

func set_flying(is_flying):
	flying = is_flying
	if flying:
		timer = 0

func _process(delta):
	if flying:
		timer += delta
		var height_offset = get_altitude()
		set_global_pos(parent.get_global_pos() + Vector2(0, normal_offset + height_offset * height_mult))
	else:
		set_global_pos(parent.get_global_pos() + Vector2(0, normal_offset))

#fancy quadratic height thingy
func get_altitude():
	var q = timer / time_to_highest
	return (-q * q + 2 * q) * height_mult