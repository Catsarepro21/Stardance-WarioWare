extends Area2D

var coin_was_collected: bool = false

func collect_bonus_coin() -> void:
	coin_was_collected = true

func _on_body_entered(body: Node2D) -> void:
	if not visible:
		return
	if body.is_in_group("Player"):
		GlobalScript.play_sfx("win")
		var level = get_tree().current_scene
		if level:
			if "temp_coins" in level:
				GlobalScript.coins += level.temp_coins
			var target_level_id = "Platformer_Minigame_1"
			if level.name == "dropper_minigame" or level.name == "Dropper_Minigame":
				target_level_id = "Dropper_Minigame"
			elif "level_id" in level:
				target_level_id = level.level_id
			GlobalScript.complete_level(target_level_id, coin_was_collected)
			GlobalScript.session_time = 0.0
		get_tree().change_scene_to_file.call_deferred("res://Scenes/level_screen.tscn")
