extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var level = get_tree().current_scene
		
		print("Flag triggered by player.")
		print("Current scene name: ", level.name)
		
		if "temp_coins" in level:
			print("Found temp_coins: ", level.temp_coins)
			GlobalScript.coins += level.temp_coins
			print("New GlobalScript.coins total: ", GlobalScript.coins)
		else:
			print("ERROR: temp_coins property not found on scene root: ", level)
			
		GlobalScript.session_time = 0.0
		get_tree().change_scene_to_file.call_deferred("res://Scenes/level_screen.tscn")
