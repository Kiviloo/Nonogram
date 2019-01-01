extends Button

func _on_EditorButton_pressed():
	get_tree().change_scene('res://Editor/size_selection.tscn')
