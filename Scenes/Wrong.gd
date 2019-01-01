extends Area2D

signal WrongButton
var buttonSprite

func _ready():
	buttonSprite = get_node("Wrong")

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.is_pressed():
		self.on_click()

func on_click():
	emit_signal("WrongButton")
	buttonSprite.texture = load("res://Texture/select_wrong_selected.png")

func _on_Right_RightButton():
	buttonSprite.texture = load("res://Texture/select_wrong.png")