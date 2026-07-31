extends Node2D


func _process(delta: float) -> void:
	var time_left: float = %Timer.time_left
	var seconds: int = (time_left)
	var milliseconds: int = int((time_left - seconds) *100)

	%TimerLabel.text = "%02d:%02d" % [seconds, milliseconds]
	
func _on_minigame_timeout() -> void:
	%"Level Label".text = "TIME UP"
	GlobalScript.game_running = false
	get_tree().paused
	await get_tree().create_timer(3.0, true, false, true).timeout
	get_tree().change_scene_to_file("res://Scenes/level_screen.tscn")
