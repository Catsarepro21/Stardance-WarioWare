extends Area2D

@export var is_falling: bool = false
@export var fall_speed: float = 150.0

func _physics_process(delta: float) -> void:
	if is_falling:
		position.y += fall_speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") or body.name == "player" or body.name == "Player":
		GlobalScript.play_sfx("coin")
		var level = get_tree().current_scene
		if level and level.has_method("add_coin"):
			level.add_coin()
		elif level and level.has_method("add_temp_coin"):
			level.add_temp_coin()
		
		if level:
			var exit_flag_node = level.find_child("exit_flag", true, false)
			if exit_flag_node and exit_flag_node.has_method("collect_bonus_coin"):
				exit_flag_node.collect_bonus_coin()
			
		queue_free()
