extends Button

func _on_10x10_pressed():
	global.size_selection = 10
	get_tree().change_scene('res://Editor/Editor.tscn')
