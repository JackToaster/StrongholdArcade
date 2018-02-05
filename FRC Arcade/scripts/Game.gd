extends Node2D

var preload_high_scores = preload("res://Scenes/High Scores.tscn")

onready var red_score = get_node("GUI/Control/red score")
onready var blue_score = get_node("GUI/Control/blue score")
onready var time = get_node("GUI/Control/Time remaining")

export(NodePath) var red_bot_path
export(NodePath) var blue_bot_path

onready var red_bot = get_node(red_bot_path)
onready var blue_bot = get_node(blue_bot_path)

var red_defenses = 5
var blue_defenses = 5

var red_health = true
var blue_health = true

signal poll_endgame

func _ready():
	Globals.set("game path", get_path())

#awards points when a defense is damaged
func defense_damaged(is_red):
	if is_red:
		blue_score.call("increment_score", 5)
	else:
		red_score.call("increment_score", 5)

#award points and check for breach
func defense_breached(is_red):
	defense_damaged(is_red)
	if is_red:
		red_defenses -= 1
		if red_defenses == 1:
			blue_score.call("increment_score", 20)
	else:
		blue_defenses -= 1
		if blue_defenses == 1:
			red_score.call("increment_score", 20)

func ball_scored(is_high, is_red):
	if is_red:
		ball_scored_red(is_high)
	else:
		ball_scored_blue(is_high)

func ball_scored_red(high):
	if high:
		blue_score.call("increment_score", 5)
	else:
		blue_score.call("increment_score", 2)

func ball_scored_blue(high):
	if high:
		red_score.call("increment_score", 5)
	else:
		red_score.call("increment_score", 2)

func castle_captured(is_red):
	if is_red:
		red_captured()
	else:
		blue_captured()

func red_captured():
	if !red_health:
		blue_score.call("increment_score", 25)
	else:
		blue_score.call("increment_score", 5)

func blue_captured():
	if !blue_health:
		red_score.call("increment_score", 25)
	else:
		red_score.call("increment_score", 5)

func castle_destroyed(is_red):
	if is_red:
		red_health = false
	else:
		blue_health = false

func score_end_game():
	emit_signal("poll_endgame")

func _on_Time_remaining_end():
	activate_bots(false)
	score_end_game()
	high_scores()

func activate_bots(active):
	print("activate called")
	if red_bot.has_method("set_active"):
		red_bot.set_active(active)
	if blue_bot.has_method("set_active"):
		blue_bot.set_active(active)

func high_scores():
	var hs = preload_high_scores.instance()
	hs.start(red_score.score, blue_score.score)
	add_child(hs)

func _on_game_start():
	time.start()
	activate_bots(true)
