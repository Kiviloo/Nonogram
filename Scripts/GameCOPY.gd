extends Node

var pixelImageTexture = preload("res://Texture/pixelSprite.png")
var pixelAmount = pixelImageTexture.get_height() * pixelImageTexture.get_width()
var pixelImage = pixelImageTexture.get_data()


var pixelImageInst = load("res://Scenes/pixelSprite.tscn")
var blockInst = load("res://Scenes/block.tscn")
var wrongInst = load("res://Scenes/wrong.tscn")

var topBannerInst = load("res://Scenes/topBanner.tscn")
var botBannerInst = load("res://Scenes/botBanner.tscn")

var alreadyClicked = Array()


func _ready():

	pixelImage.lock()
	spawnBlocksLoop()
	spawnImage()
	spawnBanner()
	pass



func _input(event):

	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.is_pressed():

		var whichPixel = Vector2(int((event.position.x - 450) / 60), int((event.position.y - 150) / 60))

		if pixelImage.get_pixel(whichPixel.x, whichPixel.y).a == 0:

			if !alreadyClicked.has(whichPixel):
				alreadyClicked.append(whichPixel)
				spawnWrong(round((event.position.x / 60)) * 60, round((event.position.y / 60)) * 60)


func spawnWrong(posx, posy):

	var image = wrongInst.instance()
	image.set_name("wrongSprite")
	get_node("/root/Game/World/Wrong").add_child(image)

	image.set_position(Vector2(posx, posy))
	image.set_scale(Vector2(12, 12))


func spawnImage():

	var image = pixelImageInst.instance()
	image.set_name("pixelSprite")
	get_node("/root/Game/World/PixelImage").add_child(image)

	image.set_position(Vector2(600, 300))
	image.set_scale(Vector2(60, 60))


func spawnBlocks(posx, posy):

	var block = blockInst.instance()
	block.set_name("WrongImg")
	get_node("/root/Game/World/Blocks").add_child(block)

	block.get_child(0).set_position(Vector2(posx, posy))


func spawnBlocksLoop():

	var i = 0
	var j = 0

	var posy = 120

	while(i<5):
		posy = posy + 60
		j = 0

		while(j<5):
			var posx = 480
			posx = posx + 60 * j
			spawnBlocks(posx, posy)
			j = j + 1
		i = i + 1


func spawnBanner():

	var i = 0
	var j = 0

	while(i<5):
		var topx = 480 + (i * 60)
		var topy = 60
		var topBanner = topBannerInst.instance()
		get_node("/root/Game/World/Banner").add_child(topBanner)
		topBanner.set_position(Vector2(topx, topy))
		i = i + 1

	while(j<5):
		var botx = 360
		var boty = 180 + (j * 60)
		var botBanner = botBannerInst.instance()
		get_node("/root/Game/World/Banner").add_child(botBanner)
		botBanner.set_position(Vector2(botx, boty))
		j = j + 1





