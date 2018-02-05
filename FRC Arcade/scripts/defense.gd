extends Node2D

export(NodePath) var half_field

var is_red

var health = 2

onready var outer = get_node("outer")
onready var inner = get_node("inner")

func _ready():
	is_red = get_node(half_field).call("get_red")
	

func damage():
	if health == 2:
		outer.hide()
		get_node(Globals.get("game path")).call("defense_damaged", is_red)
	elif health == 1:
		inner.hide()
		get_node(Globals.get("game path")).call("defense_breached", is_red)
	
	health -= 1
