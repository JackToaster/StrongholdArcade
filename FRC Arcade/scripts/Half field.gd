extends Node2D

export(String, DIR) var defenses_path

export(bool) var is_red

var defense_load = []

var defense_positions = [0,0,0,0]

signal poll_endgame

func _ready():
	var defense_paths = list_files_in_directory(defenses_path)
	for path in defense_paths:
		defense_load.append(load(defenses_path + "/" + path))
	randomize_defenses()

func randomize_defenses():
	#fill up slots without reuse
	for i in [0,1,2,3]:
		var defense_load_index = randi() % defense_load.size()
		defense_positions[i] = defense_load[defense_load_index]
		defense_load.remove(defense_load_index)

		var defense_node = get_node("Defenses/defense" + String(i))
		print(defense_positions)
		var defense_obj = defense_positions[i].instance()
		defense_node.add_child(defense_obj)


func list_files_in_directory(path):
    var files = []
    var dir = Directory.new()
    dir.open(path)
    dir.list_dir_begin()

    while true:
        var file = dir.get_next()
        if file == "":
            break
        elif not file.begins_with("."):
            files.append(file)

    dir.list_dir_end()

    return files

func get_red():
	return is_red


func _on_Root_poll_endgame():
	emit_signal("poll_endgame")
