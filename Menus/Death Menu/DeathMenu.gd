extends Control


func _on_respawn_pressed():
	get_tree().change_scene_to_file("res://Main.tscn")


func _on_quit_to_main_menu_pressed():
	get_tree().change_scene_to_file("res://Menus/Main Menu/MainMenu.tscn")
