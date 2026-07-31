extends Area2D
		
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var level = get_tree().current_scene
		
		if "temp_coins" in level:
			GlobalScript.coins  += level.temp_coins
