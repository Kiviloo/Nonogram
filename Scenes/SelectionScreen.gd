extends Control

onready var labelLevel = get_node("Menu/Label")
onready var logoSprite = get_node("Menu/Logo/CenterContainer/MapSprite")
var levelNumber = 0
var maxSprite = global.allLevels.size() -1

export(Array) var finishedLevels = global.finishedLevels

var done = Array()

func _ready():
	
	spawnImage()
	autosave()

func autosave():
	if global.autosave == true:
		savegame.save_game()

func to_save():
	finishedLevels = global.finishedLevels
	return finishedLevels

func spawnImage():
	
	var spriteString = String("res://Texture/UnknownYet.png")
	var unknownSprite = String("res://Texture/UnknownYet.png")

	for x in global.finishedLevels.size():
		done.append(int(global.finishedLevels[x]))
	
	if done.has(levelNumber):
		spriteString = String("res://Texture/"+String(levelNumber)+".png")
		var pixelImageTexture = load(spriteString)
		logoSprite.set_texture(pixelImageTexture)
		logoSprite.set_scale(Vector2(60, 60))
	else:
		spriteString = String("res://Texture/"+String(levelNumber)+".png")
		var pixelImageTexture = load(unknownSprite)
		logoSprite.set_texture(pixelImageTexture)
		logoSprite.set_scale(Vector2(60, 60))
	
	global.chosenLevelSprite = spriteString
	global.chosenLevelNumber = levelNumber
	
	labelLevel.set_text("Level: "+String(levelNumber))
	
	print (levelNumber)

func _on_LeftButton_pressed():
	
	if levelNumber <= 0:
		levelNumber = maxSprite
	else:
		levelNumber = levelNumber -1
	spawnImage()


func _on_RightButton_pressed():
	
	if levelNumber >= maxSprite:
		levelNumber = 0
	else: 
		levelNumber = levelNumber +1
	
	spawnImage()


func _on_PlayBUtton_pressed():
	get_tree().change_scene('res://Scenes/Game.tscn')


func _on_BackButton2_pressed():
	get_tree().change_scene('res://Scenes/TitleScreen.tscn')


func _on_QuestionMark_pressed():
	get_tree().change_scene('res://Scenes/Tutorial.tscn')
