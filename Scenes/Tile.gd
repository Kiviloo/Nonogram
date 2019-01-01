extends Area2D

signal RightButton
var buttonSprite

func _ready():
	buttonSprite = get_node("Tile")

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.is_pressed():
		self.on_click()

func on_click():
	emit_signal("RightButton")
	buttonSprite.texture = load("res://Texture/select_right_selected.png")

func _on_Wrong_WrongButton():
	buttonSprite.texture = load("res://Texture/select_right.png")
