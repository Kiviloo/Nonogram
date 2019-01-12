extends Node

const SAVE_PATH = "res://savegame.json"
const SAVE_LEVEL_PATH = "res://levels.json"
const SAVE_CUSTOM_LEVEL_PATH = "res://customs.json"


var custom_level_array 


func load_custom_levels():
	
	var save_file = File.new()
	if not save_file.file_exists(SAVE_CUSTOM_LEVEL_PATH):
		return
		
	
	save_file.open(SAVE_CUSTOM_LEVEL_PATH, File.READ)
	var json = save_file.get_as_text()
	var json_result = JSON.parse(json).result
	
	for section in json_result.keys():
		global.custom_level_information[section] = json_result[section] 
	
	save_file.close()
	
	global.customLevelNumber = global.custom_level_information.size() - 1

func save_custom_levels():
	
	custom_level_array = global.custom_level_information
	
	var saveNodes = get_tree().get_nodes_in_group('custom_levels')
	var allLevelsSave = Array()
	
	allLevelsSave = saveNodes[0].to_save()

	var save_file = File.new()
	save_file.open(SAVE_CUSTOM_LEVEL_PATH, File.WRITE)
	save_file.store_line(to_json(allLevelsSave))
	save_file.close()
	
	pass

func save_levels():
	var saveNodes = get_tree().get_nodes_in_group('save_levels')
	var allLevelsSave = Array()
	
	allLevelsSave = saveNodes[0].to_save()

	var save_file = File.new()
	save_file.open(SAVE_LEVEL_PATH, File.WRITE)
	save_file.store_line(to_json(allLevelsSave))
	save_file.close()


func save_game():
	var saveNodes = get_tree().get_nodes_in_group('save')
	var finishedLevelsSave = Array()
	
	finishedLevelsSave = saveNodes[0].to_save()
	
	
	var save_file = File.new()
	save_file.open(SAVE_PATH, File.WRITE)
	
	save_file.store_line(to_json(finishedLevelsSave))
	
	save_file.close()
	

func load_game():
	
	var save_file = File.new()
	if not save_file.file_exists(SAVE_PATH):
		return
		
	
	save_file.open(SAVE_PATH, File.READ)
	var json = save_file.get_as_text()
	var json_result = JSON.parse(json).result
	
	for x in json_result:
		global.finishedLevels.append(x)
	
	save_file.close()
	