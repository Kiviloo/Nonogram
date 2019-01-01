extends Button

func _on_5x5_pressed():
	global.size_selection = 5
	get_tree().change_scene('res://Editor/Editor.tscn')
