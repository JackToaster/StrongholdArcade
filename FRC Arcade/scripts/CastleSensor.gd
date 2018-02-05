extends Area2D

onready var half_field = get_node("../..")

var is_red

func _ready():
	is_red = half_field.call("get_red")

func _on_Half_field_poll_endgame():
	if bot_in():
		get_node(Globals.get("game path")).call("castle_captured", is_red)

func bot_in():
	for body in get_overlapping_bodies():
		if body.is_in_group("robots"):
			return true
	return false