extends Control

export (NodePath) var dropdown_path = "Menu/CenterRow/Buttons/DropDown"
export (NodePath) var checkbox_path = "Menu/CenterRow/Buttons/CheckBox"
export (NodePath) var hslider_path = "Menu/CenterRow/Buttons/HSlider"
onready var dropdown = get_node(dropdown_path)
onready var checkbox = get_node(checkbox_path)
onready var hslider = get_node(hslider_path)

var options = {}
var locals = {}

#var options = {"resolution_x": 1366, "resolution_y": 768, "fullscreen": false, "volume": 0.5}

var resolution = Vector2()
var fullscreen 

func _ready():
	d_add_items()
	start_options()
	
	dropdown.connect("item_selected", self, "on_item_selected")
	
	save_settings()

func start_options():
	options = settings.sets
	locals = settings.locals
	
	dropdown.select(settings.locals["locals"]["id"])
	
	if settings.sets["resolution"]["fullscreen"] == true:
		checkbox.pressed = true
		
	
	print(settings.locals["locals"]["id"])

func save_settings():
	settings.sets = options
	settings.locals = locals
	settings.save_settings()

func load_settings():
	pass

func d_add_items():
	dropdown.add_item("1920x1080")
	dropdown.add_item("1440x900")
	dropdown.add_item("1366x768")
	dropdown.add_item("1280x800")
	dropdown.add_item("1024x768")

func on_item_selected(id):
	
	if id == 0:
		resolution = Vector2(1920, 1080)
	elif id == 1:
		resolution = Vector2(1440, 900)
	elif id == 2:
		resolution = Vector2(1366, 768)
	elif id == 3:
		resolution = Vector2(1280, 800)
	elif id == 4:
		resolution = Vector2(1024, 768)
	
	
	options["resolution"]["resolution_x"] = resolution.x
	options["resolution"]["resolution_y"] = resolution.y
	
	locals["locals"]["id"] = id
	
	refresh()


func refresh():
	
	save_settings()
	
	OS.set_window_size(Vector2(options["resolution"]["resolution_x"],options["resolution"]["resolution_y"]))
	OS.set_window_fullscreen(options["resolution"]["fullscreen"])


func _on_CheckBox_toggled(button_pressed):
	if button_pressed == true:
		fullscreen = true
	else:
		fullscreen = false
	
	options["resolution"]["fullscreen"] = fullscreen
	
	refresh()
