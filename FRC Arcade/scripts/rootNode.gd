extends Node2D

onready var viewport = get_node("Viewport")
onready var input_timeout = get_node("input timeout")
onready var preload_menu = preload("res://Scenes/Menu.tscn")
onready var preload_game = preload("res://Scenes/Game.tscn")

export(String, FILE, "*.scores") var highscore_path

enum STATE{
	menu,
	game
}

var state = STATE.menu

var can_input = true

func _ready():
	set_process_input(true)
	Globals.set("root path", get_path())
	Globals.set("score file", highscore_path)

func _input(event):
	if can_input:
		viewport.input(event)

func _on_Environment_start_game():
	if state == STATE.menu:
		state = STATE.game
		viewport.get_node("Root").queue_free()
		viewport.add_child(preload_game.instance())

func to_menu():
	can_input = false
	viewport.get_children()[0].queue_free()
	viewport.add_child(preload_menu.instance())
	state = STATE.menu
	input_timeout.start()


func _on_input_timeout_timeout():
	can_input = true
