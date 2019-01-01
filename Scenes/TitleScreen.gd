extends Control

var LEVEL_PATH = "res://Texture"
var files = Array()
var filteredFiles = Array()
export(Array) var loadedLevels = global.allLevels #????

func _ready():
	loadsave()
	filteredFiles = filterLevels()
	savegame.save_levels()


func loadsave():
	savegame.load_game()
	settings.load_settings()
	settings.refresh()
	pass

func to_save():
	global.allLevels = filterLevels()
	return filteredFiles

func filterLevels():
	
	var levels = loadLevels()
	var filteredLevels = Array()
	
	for x in levels.size():
		if singleLevelExtractionFacility(x, levels) != null:
			filteredLevels.append(singleLevelExtractionFacility(x, levels))
	return filteredLevels

func singleLevelExtractionFacility(x, levels):
	
	for y in levels.size():
		if levels[y] == String(x)+".png" \
		and levels[y] != null:
			return levels[y]

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