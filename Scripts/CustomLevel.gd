extends Node

func create_custom_level(level):
	var image = Image.new()
	var levelNumber = level - global.allLevels.size()
	var imageTexture = ImageTexture.new()
	
	global.size_selection = global.custom_level_information[String(levelNumber)].size()
	
	image.create(global.size_selection,global.size_selection,false,Image.FORMAT_RGBA8)
	image.lock()
	
	for x in global.custom_level_information[String(levelNumber)].size():
		for y in global.custom_level_information[String(levelNumber)][x].size():
			if global.custom_level_information[String(levelNumber)][x][y] == 1:
				image.set_pixel(y,x,Color(0,0,0,1))
	
	image.unlock()
	
	
	imageTexture.create_from_image(image, 0)
	return imageTexture