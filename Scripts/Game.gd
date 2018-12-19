extends Node

var pixelImageTexture = load(global.chosenLevelSprite)
var pixelAmount = pixelImageTexture.get_height() * pixelImageTexture.get_width()
var pixelImage = pixelImageTexture.get_data()


var pixelImageInst = load("res://Scenes/pixelSprite.tscn")
var blockInst = load("res://Scenes/block.tscn")
var wrongInst = load("res://Scenes/wrong.tscn")

var topBannerInst = load("res://Scenes/topBanner.tscn")
var botBannerInst = load("res://Scenes/botBanner.tscn")

var noTileInst = load("res://Scenes/noTile.tscn")

var alreadyClickedWrong = Array()
var alreadyClickedRight = Array()

var greyNumbersTop = Array()
var greyNumbersBot = Array()

var blockArray = Array()

var labelGroupBot = 0
var labelGroupTop = 0

var howManyBlocks = 0

onready var lifeLabel = get_node("World/LifeLabel")
var lives = 3

func _ready():

	pixelImage.lock()
	spawnBlocksLoop()
	spawnImage()
	spawnBanner()
	zaehlerTop()
	zaehlerBot()
	createBlockArray()
	countBlocks()
	pass
	


func _input(event):
	
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.is_pressed():
		var whichPixel = Vector2(int((event.position.x - 450) / 60), int((event.position.y - 300) / 60))
		
		if pixelImage.get_pixel(whichPixel.x, whichPixel.y).a == 0:
			
			if !alreadyClickedWrong.has(whichPixel):
				alreadyClickedWrong.append(whichPixel)
				spawnWrong(480 + (whichPixel.x * 60), 330 + (whichPixel.y * 60))
				lives = lives -1
				lifeLabel.set_text("Lives: "+String(lives))
				checkLose()

		elif pixelImage.get_pixel(whichPixel.x, whichPixel.y).a == 1:
			if !alreadyClickedRight.has(whichPixel):
				alreadyClickedRight.append(whichPixel)
				checkGreysBot(alreadyClickedRight,whichPixel)
				checkGreysTop(alreadyClickedRight,whichPixel)
				checker(alreadyClickedRight)
				
				winwin()
				
				print (howManyBlocks, " ", alreadyClickedRight.size())

func checkLose():
	if lives <= 0:
		get_tree().change_scene('res://Scenes/SelectionScreen.tscn')

func countBlocks():
	for x in pixelImage.get_width():
		for y in pixelImage.get_height():
			if pixelImage.get_pixel(x,y).a == 1:
				howManyBlocks = howManyBlocks +1

func winwin():
	if alreadyClickedRight.size() == howManyBlocks:
		print ("WINWINWININ")
		global.finishedLevels.append(global.chosenLevelNumber)
		get_tree().change_scene('res://Scenes/SelectionScreen.tscn')


func checkGreysTop(clicked, mousePosition):
	var tempBlockArray = Array()
	var tempBlackArray = Array()
	var tmpBlack = 0
	var tmpCnt = 0

	var cntBlack = 0
	var cntHit = 0
	var number = 0
	
	var height = pixelImage.get_height() - 1
	
	var beforeRowNumbers = 0

	for y in pixelImage.get_height():
		
		if pixelImage.get_pixel(mousePosition.x, y).a == 1:
			tmpBlack = tmpBlack +1
			tempBlackArray.append(Vector2(mousePosition.x, y))
	
		if pixelImage.get_pixel(mousePosition.x, y).a == 0 \
		and tmpBlack != 0\
		or y >= pixelImage.get_height() -1 \
		and tmpBlack != 0:
			tmpCnt = tmpCnt +1

			if !tempBlockArray.has(Vector2(tmpCnt, tmpBlack)):
				tempBlockArray.append(Vector2(tmpCnt, tmpBlack))
			
			tmpBlack = 0
#			print ("Black Array: ", tempBlockArray, " BlockArray: ", tempBlackArray, " ", "Y: ", y, " ", "MP: ", mousePosition.x, " ", "Im: ", pixelImage.get_pixel(y, mousePosition.x).a)
		y = y +1
	
	tmpBlack = 0
	tempBlockArray.invert()
	
	for x in mousePosition.x:
		for y in pixelImage.get_height():
			
			if pixelImage.get_pixel(x, y).a == 1:
				tmpBlack = tmpBlack +1

			if pixelImage.get_pixel(x, y).a == 0 \
			and tmpBlack != 0 \
			or y >= pixelImage.get_height() - 1 \
			and tmpBlack != 0:
				beforeRowNumbers = beforeRowNumbers +1
				
				tmpBlack = 0
			
	#		print ("MP: ", x, " ", "y: ", y, " ", "bRN: ", beforeRowNumbers, " ", "tmpBlack: ", tmpBlack)
	
	for y in pixelImage.get_height():
		
		if pixelImage.get_pixel(mousePosition.x, y).a == 1:
			cntBlack = cntBlack +1

			if clicked.has(Vector2(mousePosition.x, y)):
				cntHit = cntHit +1

		
		if pixelImage.get_pixel(mousePosition.x, y).a == 0 \
		and cntBlack != 0 \
		or y >= pixelImage.get_height() -1 \
		and cntBlack != 0:
			number = number +1
			if cntBlack == cntHit:
				if !greyNumbersTop.has(tempBlockArray[number-1].x + beforeRowNumbers):
					greyNumbersTop.append(tempBlockArray[number-1].x + beforeRowNumbers)
#					print(greyNumbersBot)
					var enemies = get_tree().get_nodes_in_group("zaehlerTop")
					for zaehler in enemies:
						zaehler.queue_free()
					labelGroupTop = 0
					zaehlerTop()
					print (tempBlockArray[number-1].x + beforeRowNumbers)
			
			cntBlack = 0
			cntHit = 0

	



func checkGreysBot(clicked, mousePosition):
	
	var tempBlockArray = Array()
	var tempBlackArray = Array()
	var tmpBlack = 0
	var tmpCnt = 0

	var cntBlack = 0
	var cntHit = 0
	var number = 0
	
	var width = pixelImage.get_width() -1
	
	var beforeRowNumbers = 0
	

	while width >= 0:
		
		if pixelImage.get_pixel(width, mousePosition.y).a == 1:
			tmpBlack = tmpBlack +1
			tempBlackArray.append(Vector2(width, mousePosition.y))
		
		if pixelImage.get_pixel(width, mousePosition.y).a == 0 \
		and tmpBlack != 0 \
		or width == 0 \
		and tmpBlack != 0:
			tmpCnt = tmpCnt +1

			if !tempBlockArray.has(Vector2(tmpCnt, tmpBlack)):
				tempBlockArray.append(Vector2(tmpCnt, tmpBlack))
			
			tmpBlack = 0
	#		print ("Black Array: ", tempBlockArray)
		width = width -1
	
	tempBlockArray.invert()
	
	tmpBlack = 0
	
	
	for y in mousePosition.y:
		for x in pixelImage.get_width():
			
			if pixelImage.get_pixel(x, y).a == 1:
				tmpBlack = tmpBlack +1

			if pixelImage.get_pixel(x, y).a == 0 \
			and tmpBlack != 0 \
			or x >= pixelImage.get_width() - 1 \
			and tmpBlack != 0:
				beforeRowNumbers = beforeRowNumbers +1
				
				tmpBlack = 0
	
	
	for x in pixelImage.get_width():
		
		if pixelImage.get_pixel(x, mousePosition.y).a == 1:
			cntBlack = cntBlack +1

			if clicked.has(Vector2(x, mousePosition.y)):
				cntHit = cntHit +1

		
		if pixelImage.get_pixel(x, mousePosition.y).a == 0 \
		and cntBlack != 0 \
		or x >= pixelImage.get_width() -1 \
		and cntBlack != 0:
			number = number +1
			if cntBlack == cntHit:
				if !greyNumbersBot.has(tempBlockArray[number-1].x + beforeRowNumbers):
					greyNumbersBot.append(tempBlockArray[number-1].x + beforeRowNumbers)
#					print(greyNumbersBot)
					var enemies = get_tree().get_nodes_in_group("zaehlerBot")
					for zaehler in enemies:
						zaehler.queue_free()
					labelGroupBot = 0
					zaehlerBot()
			
			cntBlack = 0
			cntHit = 0
	

func createBlockArray():
	var x = pixelImage.get_width()
	
	while x >= 0:
		for y in pixelImage.get_height():
			if pixelImage.get_pixel(x,y).a == 1:
				blockArray.append(Vector2(x,y))
#				print (y, x)
		x = x -1

func checker(array):
	var arrayBack = array.back()
	var i = 0
	var allCntX = 0
	var realCntX = 0
	var allCntY = 0
	var realCntY = 0
	var howMany = 0
	
	while (i < pixelImageTexture.get_width()):
		if pixelImage.get_pixel(i, arrayBack.y).a == 1:
			allCntX = allCntX + 1

			
			if pixelImage.get_pixel(i+1, arrayBack.y).a == 1 \
			or pixelImage.get_pixel(i+1, arrayBack.y).a == null:
				howMany = howMany + 1
			
			if array.has(Vector2(i, arrayBack.y)):
				realCntX = realCntX + 1

		elif pixelImage.get_pixel(i,arrayBack.y).a == 0:
			howMany = howMany + 1
		i = i + 1
	
	i = 0
	
	while (i < pixelImageTexture.get_height()):
		if pixelImage.get_pixel(arrayBack.x, i).a == 1:
			allCntY = allCntY + 1
			if array.has(Vector2(arrayBack.x, i)):
				realCntY = realCntY + 1
		i = i + 1
	
	
	if allCntX == realCntX:
		columnComplete(arrayBack, 0)
	if allCntY == realCntY:
		columnComplete(arrayBack, 1)


func columnComplete(where, toporbot):
	var i = 0
	
	if toporbot == 0:
		while (i < pixelImageTexture.get_width()):
			if pixelImage.get_pixel(i, where.y).a == 0:
				var image = noTileInst.instance()
				image.set_name("noTileHereSprite")
				get_node("/root/Game/World/NoTiles").add_child(image)
				image.set_scale(Vector2(12, 12))
				image.set_position(Vector2(480 + (i * 60), 330 + (where.y * 60)))
				
				for block in get_tree().get_nodes_in_group("Y"+String(where.y)):
					block.queue_free()
			i = i + 1
	
	if toporbot == 1:
		while (i < pixelImageTexture.get_height()):
			if pixelImage.get_pixel(where.x, i).a == 0:
				var image = noTileInst.instance()
				image.set_name("noTileHereSprite")
				get_node("/root/Game/World/NoTiles").add_child(image)
				image.set_scale(Vector2(12, 12))
				image.set_position(Vector2(480 + (where.x * 60), 330 + (i * 60)))
				
				for block in get_tree().get_nodes_in_group("X"+String(where.x)):
					block.queue_free()
			i=i+1

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
	
	image.set_position(Vector2(600, 450))
	image.set_scale(Vector2(60, 60))


func spawnBlocks(posx, posy):
	
	var block = blockInst.instance()
	block.set_name("WrongImg")
	get_node("/root/Game/World/Blocks").add_child(block)
	
	block.get_child(0).set_position(Vector2(posx, posy))
	
	var GrpNameX = "X"+String((posx/60)-8)
	var GrpNameY = "Y"+String((posy/60)-5)
	
	block.add_to_group(GrpNameX)
	block.add_to_group(GrpNameY)


func spawnBlocksLoop():
	
	var i = 0
	var j = 0
	
	var posy = 270
	
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
		var topy = 210
		var topBanner = topBannerInst.instance()
		get_node("/root/Game/World/Banner").add_child(topBanner)
		topBanner.set_position(Vector2(topx, topy))
		i = i + 1
		 
	while(j<5):
		var botx = 360
		var boty = 330 + (j * 60)
		var botBanner = botBannerInst.instance()
		get_node("/root/Game/World/Banner").add_child(botBanner)
		botBanner.set_position(Vector2(botx, boty))
		j = j + 1


func zaehlerBot():
	var i = pixelImageTexture.get_width() - 1
	var j = 0
	var howMany = 0
	var firstTime = true
	var number = 0
	var toporbot = 0
	var ort = 2
	
	while(j<pixelImageTexture.get_height()):
		while(i>=0):
			
			if pixelImage.get_pixel(i, j).a == 1:
				firstTime = true
				howMany = howMany + 1
				
				if firstTime == true:
					number = number + 1
					
			elif pixelImage.get_pixel(i,j).a == 0 \
			and firstTime == true \
			and howMany != 0:
				changeLabelBot(howMany, j, number,ort, toporbot)
				howMany = 0
				ort = ort - 1
				number = 0
				firstTime = false
			i = i - 1
			
		if howMany != 0:
			changeLabelBot(howMany, j, number,ort, toporbot)
			#print(howMany, " ", j, " ", number)
			howMany = 0
			ort = ort - 1
			number = 0
			firstTime = false
		
		i = pixelImageTexture.get_width() - 1
		j = j + 1
		ort = 2
	
	if howMany != 0:
		changeLabelBot(howMany, j, number,ort, toporbot)
		#print(howMany, " ", j, " ", number)
		howMany = 0
		ort = ort - 1
		number = 0
		firstTime = false

func zaehlerTop():
	var i = 0
	var j = pixelImageTexture.get_height() - 1
	var howMany = 0
	var firstTime = true
	var number = 0
	var toporbot = 0
	var ort = 2
	
	while(i < pixelImageTexture.get_width()):
		while(j >= 0):
			print (i,j)
			if pixelImage.get_pixel(i, j).a == 1:
				firstTime = true
				howMany = howMany + 1
				
				if firstTime == true:
					number = number + 1
				
			elif pixelImage.get_pixel(i,j).a == 0 \
			and firstTime == true \
			and howMany != 0:
				changeLabelTop(howMany, i, number,ort, toporbot)
				howMany = 0
				number = 0
				ort = ort - 1
				firstTime = false
			j = j - 1
			
		if howMany != 0:
			changeLabelTop(howMany, i, number,ort, toporbot)
			#print(howMany, " ", i, " ", number)
			howMany = 0
			ort = ort - 1
			number = 0
			firstTime = false
			
		j = pixelImageTexture.get_width() - 1
		i = i + 1
		ort = 2
	
	if howMany != 0:
		changeLabelTop(howMany, i, number,ort, toporbot)
		print(howMany, " ", i, " ", number)
		howMany = 0
		ort = ort - 1
		number = 0
		firstTime = false


func zaehler():
	var i = pixelImageTexture.get_width() - 1
	var j = 0
	var howMany = 0
	var firstTime = true
	var number = 0
	var toporbot = 1
	var ort = 2
	
	while(j<pixelImageTexture.get_height()):
		while(i>=0):
			
			if pixelImage.get_pixel(i, j).a == 1:
				firstTime = true
				howMany = howMany + 1
				
				if firstTime == true:
					number = number + 1
					
			elif pixelImage.get_pixel(i,j).a == 0 \
			and firstTime == true \
			and howMany != 0:
				changeLabel(howMany, j, number,ort, toporbot)
				#print(howMany, " ", j, " ", number)
				howMany = 0
				ort = ort - 1
				number = 0
				firstTime = false
			i = i - 1
			
		if howMany != 0:
			changeLabel(howMany, j, number,ort, toporbot)
			#print(howMany, " ", j, " ", number)
			howMany = 0
			ort = ort - 1
			number = 0
			firstTime = false
		
		i = pixelImageTexture.get_width() - 1
		j = j + 1
		ort = 2
	
	if howMany != 0:
		changeLabel(howMany, j, number,ort, toporbot)
		#print(howMany, " ", j, " ", number)
		howMany = 0
		ort = ort - 1
		number = 0
		firstTime = false
	
	ort = 2
	i = 0
	j = pixelImageTexture.get_height() - 1
	toporbot = 0
	
	while(i < pixelImageTexture.get_width()):
		while(j >= 0):
			
			if pixelImage.get_pixel(i, j).a == 1:
				firstTime = true
				howMany = howMany + 1
				
				if firstTime == true:
					number = number + 1
					
			elif pixelImage.get_pixel(i,j).a == 0 \
			and firstTime == true \
			and howMany != 0:
				changeLabel(howMany, i, number,ort, toporbot)
				#print(howMany, " ", i, " ", number)
				howMany = 0
				number = 0
				ort = ort - 1
				firstTime = false
			j = j - 1
			
		if howMany != 0:
			changeLabel(howMany, i, number,ort, toporbot)
			#print(howMany, " ", i, " ", number)
			howMany = 0
			ort = ort - 1
			number = 0
			firstTime = false
			
		j = pixelImageTexture.get_width() - 1
		i = i + 1
		ort = 2
	
	if howMany != 0:
		changeLabel(howMany, i, number,ort, toporbot)
		#print(howMany, " ", i, " ", number)
		howMany = 0
		ort = ort - 1
		number = 0
		firstTime = false

func changeLabelBot(howMany, which, number, ort, toporbot):
	
	var label = Label.new()
	var labelNode = Node2D.new()
	var topPosx = 480
	var topPosy = 150
	var botPosx = 300
	var botPosy = 330
	
	
	botPosx = botPosx  + (60*ort)
	botPosy = botPosy + (60*which)
	
	labelNode.position = Vector2(botPosx, botPosy)
	add_child(labelNode)
	
	label.set_text(String(howMany))
	label.add_color_override("font_color", Color(1,0,0))
	labelNode.add_child(label)
	
	
	labelGroupBot = labelGroupBot +1
	#print ((botPosx)/60-5, " ", (botPosy)/60-5)
	label.add_to_group("BotL"+String(labelGroupBot))
	label.add_to_group("zaehlerBot")
#	print (label.get_groups())
	
	for x in greyNumbersBot:
		var greenNumber = x
		
		if label.is_in_group("BotL"+String(greenNumber)):
			label.add_color_override("font_color", Color(0.2, 1.0, 0.7))
#			print ("BotL"+String(greenNumber))


func changeLabelTop(howMany, which, number, ort, toporbot):
	
	var label = Label.new()
	var labelNode = Node2D.new()
	var topPosx = 480
	var topPosy = 150
	var botPosx = 300
	var botPosy = 330
	#print (howMany, " ", which, " ",number, " ",ort, " ",toporbot)
	
	print ("woop")
	topPosx = topPosx + (60*which)
	topPosy = topPosy + (60*ort)
	
	labelNode.position = Vector2(topPosx, topPosy)
	add_child(labelNode)
	
	label.set_text(String(howMany))
	label.add_color_override("font_color", Color(1,0,0))
	labelNode.add_child(label)
	
	labelGroupTop = labelGroupTop +1
	#print ((botPosx)/60-5, " ", (botPosy)/60-5)
	label.add_to_group("TopL"+String(labelGroupTop))
	label.add_to_group("zaehlerTop")
#	print (label.get_groups())
	
	for x in greyNumbersTop:
		var greenNumber = x
		
		if label.is_in_group("TopL"+String(greenNumber)):
			label.add_color_override("font_color", Color(0.2, 1.0, 0.7))
#			print ("BotL"+String(greenNumber))