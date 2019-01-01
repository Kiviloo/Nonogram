extends Button

func _on_20x20_pressed():
	global.size_selection = 20
	get_tree().change_scene('res://Editor/Editor.tscn')
