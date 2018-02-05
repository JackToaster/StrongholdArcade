extends Label

var score = 0

func _ready():
	set_text(String(score))

func set_score(val):
	score = val
	update_disp()

func increment_score(val):
	score += val
	update_disp()

func get_score():
	return score

func update_disp():
	set_text(String(score))