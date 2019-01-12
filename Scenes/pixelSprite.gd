extends Sprite

func _ready():
	if global.customyesorno == false:
		var spriteString = String(global.chosenLevelSprite)
		var pixelImageTexture = load(spriteString)

		self.set_texture(pixelImageTexture)
	else:
		var pixelImageTexture = global.imageTexture
		
		self.set_texture(pixelImageTexture)
