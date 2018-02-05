extends Node2D

export(float) var fade_time

onready var tween = get_node("Tween")

onready var audio = get_node("StreamPlayer")
onready var modulate = get_node("CanvasModulate")

signal start_game

func _ready():
	#process inputs
	set_process_input(true)
	#set the parameters to fade
	tween.set_tween_process_mode(0)
	tween.interpolate_method(audio, "set_volume", audio.get_volume(), 0, fade_time, 0, 2)
	tween.interpolate_method(modulate, "set_color", Color(1,1,1), Color(0,0,0), fade_time, 0, 2)
	
func _input(event):
	if event.is_action("ui_accept"):		
		start_fade()

func _on_Start_Button_button_down():
	start_fade()
	
func start_fade():
	tween.start()

func _on_Tween_tween_complete(object, key):
	connect("start_game", get_node(Globals.get("root path")), "_on_Environment_start_game")
	emit_signal("start_game")

