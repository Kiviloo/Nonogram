extends Sprite

func _ready():
	
	var spriteString = String(global.chosenLevelSprite)
	var pixelImageTexture = load(spriteString)

	self.set_texture(pixelImageTexture)
