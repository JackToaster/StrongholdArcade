extends Node2D

var preload_score_entry = preload("res://Scenes/highscore entry.tscn")
var preload_score_display = preload("res://Scenes/score list.tscn")

var red_score
var blue_score

var highest

onready var tween = get_node("Tween")
onready var tint = get_node("screen tint")

var hs_entry

func _ready():
	tween.interpolate_method(tint, "set_color", Color(0,0,0,0), Color(0,0,0,0.75), 1, 0, 0)
	tween.start()

func start(rscore, bscore):
	red_score = rscore
	blue_score = bscore
	highest = max(int(red_score), int(blue_score))
	if check_for_high(highest):
		var color = ""
		if red_score > blue_score:
			color = "red"
		else:
			color = "blue"
		
		hs_entry = preload_score_entry.instance()
		var name_entry = hs_entry.get_node("name entry")
		name_entry.set_color(color)
		name_entry.set_parent(self)
		add_child(hs_entry)
	else:
		confirm_high_scores()
		show_hs()
	
	
func check_for_high(score):
	confirm_high_scores()
	var scores = read_hs_file()
	scores.sort_custom(self, "comp_scores")
	if scores.size() < 10:
		return true
	elif score > scores[9][1]:
		return true
	else:
		return false

func confirm_high_scores():
	var hs_file = File.new()
	var hs_file_path = Globals.get("score file")
	if not hs_file.file_exists(hs_file_path):
		create_hs_file(hs_file)

func create_hs_file(hs_file = File.new()):
	var hs_file_path = Globals.get("score file")
	hs_file.open(hs_file_path, File.WRITE)
	hs_file.store_var([["JACK L.", 150]])
	hs_file.close()

func read_hs_file(hs_file = File.new()):
	var hs_file_path = Globals.get("score file")
	hs_file.open(hs_file_path, File.READ)
	var hs_data = hs_file.get_var()
	hs_file.close()
	return hs_data

func write_hs_file(scores, hs_file = File.new()):
	scores.sort_custom(self, "comp_scores")
	var hs_file_path = Globals.get("score file")
	hs_file.open(hs_file_path, File.WRITE)
	hs_file.store_var(scores)
	hs_file.close()

func add_hs(score):
	var scores = read_hs_file()
	scores.append(score)
	write_hs_file(scores)

#used for sorting
func comp_scores(score1, score2):
	return score1[1] > score2[1]

func ret_name(name):
	var score = [name, highest]
	add_hs(score)
	hs_entry.queue_free()
	show_hs()

func show_hs():
	var score_list = preload_score_display.instance()
	add_child(score_list)