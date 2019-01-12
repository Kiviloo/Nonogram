extends Node

const SAVE_PATH = "res://config.cfg"
const SAVE_LOCAL_PATH = "res://locals.cfg"

var _local_file = ConfigFile.new()
var _config_file = ConfigFile.new()

var sets = {
	"resolution": {
		"resolution_x": 1366,
		"resolution_y": 768,
		"fullscreen": false
	},
	"audio": {
		"volume": 0.5
	}
}

var locals = {
	"locals": {
		"id": 0
	}

}

func save_settings():
	for section in sets.keys():
		for key in sets[section]:
			_config_file.set_value(section, key, sets[section][key])
	
	_config_file.save(SAVE_PATH)
	
	for section in locals.keys():
		for key in locals[section]:
			_local_file.set_value(section, key, locals[section][key])
			
	_local_file.save(SAVE_LOCAL_PATH)

func load_settings():
	
	var pre_error = _config_file.load(SAVE_PATH)
	if pre_error == 19:
		_config_file = ConfigFile.new()
		_config_file.save(SAVE_PATH)
		save_settings()
	
	var error = _config_file.load(SAVE_PATH)
	if error != OK:
		print ("Failed loading settigns file: ", error)
		return []
		
	for section in sets.keys():
		for key in sets[section]:
			sets[section][key] = _config_file.get_value(section, key, null) 
			
	var error_local = _local_file.load(SAVE_LOCAL_PATH)
	if error_local != OK:
		return []
	
	for section in locals.keys():
		for key in locals[section]:
			locals[section][key] = _local_file.get_value(section, key, null)


func refresh():
	print(sets["resolution"]["resolution_x"],sets["resolution"]["resolution_y"])
	OS.set_window_size(Vector2(sets["resolution"]["resolution_x"],sets["resolution"]["resolution_y"]))
	OS.set_window_fullscreen(sets["resolution"]["fullscreen"])