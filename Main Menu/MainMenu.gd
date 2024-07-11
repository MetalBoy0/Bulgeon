extends Control



func _on_start_pressed():
	get_tree().change_scene_to_file("res://Main.tscn")


func _on_settings_pressed():
	get_tree().change_scene_to_file("res://Settings.tscn")


func _on_stop_pressed():
	get_tree().quit()
