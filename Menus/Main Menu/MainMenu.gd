extends Control


#Goes to main scene
func _on_start_pressed():
	get_tree().change_scene_to_file("res://Main.tscn")

#Goes to settings scene
func _on_settings_pressed():
	get_tree().change_scene_to_file("res://Menus/Settings/Settings.tscn")

# Quits out of godot
func _on_stop_pressed():
	get_tree().quit()
