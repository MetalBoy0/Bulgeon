extends Control


#Goes To Main Scene
func _on_start_pressed():
	get_tree().change_scene_to_file("res://Main.tscn")

#Goes To Settings Scene
func _on_settings_pressed():
	get_tree().change_scene_to_file("res://Settings/Settings.tscn")

#Quits Out Of Godot
func _on_stop_pressed():
	get_tree().quit()
