extends Node2D

func _ready() -> void:
	GlobalScript.play_sfx("win")
	var time_lbl = find_child("TimeLabel", true, false)
	var coin_lbl = find_child("CoinsLabel", true, false)
	if time_lbl and time_lbl is Label:
		time_lbl.text = "FINAL TIME: " + GlobalScript.get_formatted_time()
	if coin_lbl and coin_lbl is Label:
		coin_lbl.text = "COINS COLLECTED: " + str(GlobalScript.coins)

func _on_play_again_pressed() -> void:
	GlobalScript.play_sfx("click")
	GlobalScript.lives = 3
	GlobalScript.coins = 0
	GlobalScript.time_elapsed = 0.0
	GlobalScript.game_running = true
	GlobalScript.level_data["Platformer_Minigame_1"] = {"completed": false, "bonus_coin": false}
	GlobalScript.level_data["Dropper_Minigame"] = {"completed": false, "bonus_coin": false}
	get_tree().change_scene_to_file("res://Scenes/level_screen.tscn")

func _on_title_pressed() -> void:
	GlobalScript.play_sfx("click")
	GlobalScript.lives = 3
	GlobalScript.coins = 0
	GlobalScript.time_elapsed = 0.0
	GlobalScript.game_running = false
	GlobalScript.level_data["Platformer_Minigame_1"] = {"completed": false, "bonus_coin": false}
	GlobalScript.level_data["Dropper_Minigame"] = {"completed": false, "bonus_coin": false}
	get_tree().change_scene_to_file("res://Scenes/Title_Screen.tscn")

func _on_quit_pressed() -> void:
	GlobalScript.play_sfx("click")
	get_tree().quit()
