extends Button

func _on_15x15_pressed():
	global.size_selection = 15
	get_tree().change_scene('res://Editor/Editor.tscn')
