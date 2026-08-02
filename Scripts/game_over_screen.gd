extends Node2D

func _ready() -> void:
	show()

func show_death_screen() -> void:
	show()
	get_tree().paused = true 
	GlobalScript.game_running = false

func _on_retry_pressed() -> void:
	GlobalScript.play_sfx("click")
	get_tree().paused = false
	GlobalScript.lives = 3
	GlobalScript.game_running = true
	queue_free()
	get_tree().reload_current_scene()

func _on_return_to_title_screen_pressed() -> void:
	GlobalScript.play_sfx("click")
	get_tree().paused = false
	GlobalScript.coins = 0
	GlobalScript.lives = 3
	GlobalScript.time_elapsed = 0.0
	GlobalScript.session_time = 0.0
	GlobalScript.game_running = false
	queue_free()
	get_tree().change_scene_to_file("res://Scenes/Title_Screen.tscn")

func _on_quit_pressed() -> void:
	GlobalScript.play_sfx("click")
	get_tree().quit()
