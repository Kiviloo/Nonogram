extends Control

var LEVEL_PATH = "res://Texture"
var files = Array()

func _ready():
	loadsave()
	filterLevels()

func loadsave():
	savegame.load_game()
	settings.load_settings()
	settings.refresh()
	pass
	

func filterLevels():
	
	for x in loadLevels().size():
		if loadLevels().find(String(1.png)):
	#	and !loadLevels().has(String(x)+".png"+".import"):
			print (loadLevels()[x])
	
	pass

func loadLevels():
	
	var dir = Directory.new()
	dir.open(LEVEL_PATH)
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)
			
	
	dir.list_dir_end()
	
	return files