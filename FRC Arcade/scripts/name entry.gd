extends Label

export(int) var max_len

#all the letters and symbols to enter
const alphabet = [" DONE"," DEL","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","0","1","2","3","4","5","6","7","8","9",".","!","-","_"," "]

export(NodePath) var red_p_text
export(NodePath) var blue_p_text

var selection = 2
var entry = ""

var prefix = "ui_"

export(String) var red_prefix
export(String) var blue_prefix

var parent

func _ready():
	set_process_input(true)
	update_view()

func set_color(color):
	if color == "red":
		prefix = red_prefix
		get_node(red_p_text).show()
	elif color == "blue":
		prefix = blue_prefix
		get_node(blue_p_text).show()

func set_parent(cb):
	parent = cb

func _input(event):
	print("input gotten")
	if event.is_action_pressed(prefix + "A"):
		if selection > 1:
			entry = entry + alphabet[selection]
			if entry.length() == max_len:
				selection = 0
			update_view()
		elif selection == 1:
			entry = entry.substr(0,entry.length() - 1)
			update_view()
		elif selection == 0:
			submit()
	elif event.is_action_pressed(prefix+"B"):
		entry = entry.substr(0,entry.length() - 1)
		update_view()
	elif event.is_action_pressed(prefix+"up"):
		selection = (selection + 1) % alphabet.size()
		if entry.length() == 0 and selection < 2:
			selection = 2
		elif entry.length() == max_len and selection > 1:
			selection = 0
		update_view()
	elif event.is_action_pressed(prefix+"down"):
		selection = selection - 1
		if selection < 0:
			selection += alphabet.size()
		
		if entry.length() == 0 and selection < 2:
			selection = alphabet.size() - 1
		elif entry.length() == max_len and selection > 1:
			selection = 1
		update_view()

func submit():
	parent.ret_name(entry)
	

func update_view():
	set_text(entry + alphabet[selection])
