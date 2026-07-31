extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		GlobalScript.lives -=1
		var timer_node = get_tree().current_scene.get_node_or_null("Timer")
		if timer_node:
			GlobalScript.session_time = timer_node.time_left
		get_tree().reload_current_scene()
