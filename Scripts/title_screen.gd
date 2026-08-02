extends Node2D

func _on_start_button_pressed() -> void:
	GlobalScript.play_sfx("click")
	GlobalScript.lives = 3
	GlobalScript.coins = 0
	GlobalScript.time_elapsed = 0.0
	GlobalScript.game_running = true
	get_tree().change_scene_to_file("res://Scenes/level_screen.tscn")

func _on_settings_button_pressed() -> void:
	GlobalScript.play_sfx("click")
	get_tree().change_scene_to_file("res://Scenes/settings.tscn")

func _on_quit_button_pressed() -> void:
	GlobalScript.play_sfx("click")
	get_tree().quit()
