extends Node

var grid = load("res://Editor/editor_grid.tscn")
var rahmen = load("res://Editor/Border.tscn")
var blockInst = load("res://Editor/Black_Square.tscn")

var screenSize = (Vector2(ProjectSettings.get_setting("display/window/size/width"), ProjectSettings.get_setting("display/window/size/height")))
var screenMid = (Vector2(ProjectSettings.get_setting("display/window/size/width") / 2, ProjectSettings.get_setting("display/window/size/height") / 2))
var imageTopLeft = Vector2()
var imageBotRight = Vector2()

var scale 
var size
var tinyScale

var imageArray = Array()

var drawOrerase = true

var blocks = Array()

var img = Image.new()

export(Dictionary) var level_information = {
	"0": [null],
	}

var customLevelNumber = -1

func _ready():
	
	sizeBestimmung()
	gridSetter()
	imageArray = setArray()

func _input(event):
	
	var tempImageBotRight = Vector2(imageBotRight.x - scale / 2, imageBotRight.y+ scale / 2)
	var tempImageTopLeft = Vector2(imageTopLeft.x - scale / 2, imageTopLeft.y + scale / 2)
	
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.is_pressed():
		if event.position.x < tempImageBotRight.x\
		and event.position.x >= tempImageTopLeft.x\
		and event.position.y < tempImageBotRight.y\
		and event.position.y > tempImageTopLeft.y:
			var whichPixel = Vector2(int((event.position.x - tempImageTopLeft.x) / scale), int((event.position.y - tempImageTopLeft.y) / scale))
			
			if drawOrerase == true:
				spawnBlock(whichPixel.x, whichPixel.y)
				add_to_array(whichPixel)
			elif drawOrerase == false:
				eraseBlock(whichPixel.x, whichPixel.y)
				delete_from_array(whichPixel)

func to_save():
	return level_information

func save_image():

	level_information = global.custom_level_information
	customLevelNumber = global.customLevelNumber
	customLevelNumber = customLevelNumber +1

	level_information[String(customLevelNumber)] = imageArray

	global.customLevelNumber = customLevelNumber
	global.custom_level_information = level_information
	savegame.save_custom_levels()
	
	refresh()

func refresh():
	imageArray = setArray()
	
	for block in get_tree().get_nodes_in_group("editor_block"):
		block.queue_free()

func delete_from_array(whichPixel):
	
	imageArray[whichPixel.y][whichPixel.x]=0

func add_to_array(whichPixel):
	
	imageArray[whichPixel.y][whichPixel.x]=1

func eraseBlock(posx, posy):
	
	var cnt = 0
	
	for x in blocks:
		if x.is_in_group("X"+String(posx)+" "+"Y"+String(posy)):
			blocks.remove(cnt)
			x.queue_free()
		cnt = cnt +1

func spawnBlock(posx, posy):
	var block = blockInst.instance()
	block.set_name("Block")
	get_node("/root/World/Blocks").add_child(block)
	
	block.set_position(Vector2((imageTopLeft.x + scale /2) + (posx * scale) - scale/2 , (imageTopLeft.y + scale /2) + (posy * scale) + scale / 2))
	block.set_scale(Vector2(scale, scale))
	
	block.add_to_group("X"+String(posx)+" "+"Y"+String(posy))
	block.add_to_group("editor_block")
	blocks.append(block)

func setArray():
	
	var array = []
	for i in size:
		array.append([])
		for j in size:
			array[i].append(0)
			
	return array

func sizeBestimmung():
	
	size = global.size_selection
	
	if size == 5:
		scale = 60
		tinyScale = 12
	elif size == 10:
		scale = 50
		tinyScale = 10
	elif size == 15:
		scale = 40
		tinyScale = 8
	elif size == 20:
		scale = 30
		tinyScale = 6
	
	self.imageTopLeft = Vector2(screenMid.x - ((size * scale) / 2), screenMid.y - ((size * scale) / 2))
	self.imageBotRight = Vector2(screenMid.x + size * scale / 2, screenMid.y + size * scale / 2)

func gridSetter():
	
	var pos = imageTopLeft
	
	for x in size:
		pos.y = pos.y + scale
		for y in size:
			var posx = pos.x
			posx = posx + scale * y
			gridBuilder(posx, pos.y)

func gridBuilder(posx, posy):
	
	var block = grid.instance()
	block.set_name("gridTile")
	get_node("/root/World/GridTiles").add_child(block)
	
	block.set_position(Vector2(posx, posy))
	block.set_scale(Vector2(tinyScale, tinyScale))

func _on_DrawButton_pressed():
	self.drawOrerase = true


func _on_EraserButton_pressed():
	self.drawOrerase = false


func _on_SaveButton_pressed():
	save_image()
