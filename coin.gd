extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") or body.name == "player":
		var level = get_tree().current_scene
		if level.has_method("add_coin"):
			level.add_coin
		
		queue_free()
