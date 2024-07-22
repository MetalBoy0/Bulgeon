extends Control


func _on_respawn_pressed(): # Go to main scene if respawn pressed
	get_tree().change_scene_to_file("res://Main.tscn")


func _on_quit_to_main_menu_pressed(): #Go to Main Menu if main menu pressed
	get_tree().change_scene_to_file("res://Menus/Main Menu/MainMenu.tscn")
