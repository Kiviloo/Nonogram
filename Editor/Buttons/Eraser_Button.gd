extends Button
var buttonSprite

func _ready():
	buttonSprite = get_node("EraserImg")
	buttonSprite.texture = load("res://Texture/Eraser.png")


func _on_DrawButton_pressed():
	buttonSprite.texture = load("res://Texture/Eraser.png")


func _on_EraserButton_pressed():
	buttonSprite.texture = load("res://Texture/Eraser_Selected.png")
