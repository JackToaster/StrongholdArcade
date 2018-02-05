extends Node2D

var score_holders = []

func _ready():
	set_process_input(true)
	
	var scores = read_hs_file()
	
	for i in range(1,11):
		score_holders.append(get_node("hs" + str(i)))
	
	for i in range(min(scores.size(),10)):
		score_holders[i].show()
		var name = score_holders[i].get_node("name")
		var score = score_holders[i].get_node("score")
		name.set_text(str(scores[i][0]))
		score.set_text(str(scores[i][1]))

func read_hs_file(hs_file = File.new()):
	var hs_file_path = Globals.get("score file")
	hs_file.open(hs_file_path, File.READ)
	var hs_data = hs_file.get_var()
	hs_file.close()
	return hs_data

func _input(event):
	if event.is_action_pressed("red_A") or event.is_action_pressed("red_B") or event.is_action_pressed("blue_A") or event.is_action_pressed("blue_B"):
		get_node(Globals.get("root path")).to_menu()