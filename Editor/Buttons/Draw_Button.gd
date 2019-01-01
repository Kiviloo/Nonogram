extends Button

var buttonSprite

func _ready():
	buttonSprite = get_node("DrawImg")
	buttonSprite.texture = load("res://Texture/Draw_Selected.png")

func _on_EraserButton_pressed():
	buttonSprite.texture = load("res://Texture/Draw.png")

func _on_DrawButton_pressed():
	buttonSprite.texture = load("res://Texture/Draw_Selected.png")