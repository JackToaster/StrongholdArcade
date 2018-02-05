extends Node2D

export(float) var fade_time

onready var tween = get_node("Tween")
onready var modulate = get_node("CanvasModulate")

func _ready():
	modulate.show()
	tween.set_tween_process_mode(1)
	tween.interpolate_method(modulate, "set_color", Color(0,0,0), Color(1,1,1), fade_time, 0, 2)
	tween.start()