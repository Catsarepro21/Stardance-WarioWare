extends Area2D

@export var spawn_marker: Marker2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var timer_node = get_tree().current_scene.get_node_or_null("Timer")
		if timer_node and timer_node is Timer:
			GlobalScript.session_time = timer_node.time_left
		
		if spawn_marker:
			GlobalScript.lose_life(spawn_marker.global_position)
		else:
			GlobalScript.lose_life()
