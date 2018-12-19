extends Node

const SAVE_PATH = "res://savegame.json"

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
	