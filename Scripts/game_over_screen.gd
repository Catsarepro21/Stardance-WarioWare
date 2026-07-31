extends Node2D

func _ready() -> void:
	hide()
	
func show_death_screen() -> void:
	show()
	get_tree().paused = true 
	GlobalScript.game_running = false

func _on_retry_pressed() -> void:
	get_tree().paused = false
	GlobalScript.lives = 3
	get_tree().reload_current_scene()
	GlobalScript.game_running = true
	
func _on_return_to_title_screen_pressed() -> void:
	get_tree().paused = false
	GlobalScript.coins = 0
	GlobalScript.lives = 3
	GlobalScript.time_elapsed = 0
	get_tree().change_scene_to_file("res://Scenes/Title_Screen.tscn")
	
func _on_quit_pressed() -> void:
		get_tree().quit()
