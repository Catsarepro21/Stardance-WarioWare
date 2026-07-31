extends Node2D

var temp_coins = 0

func _ready() -> void:
	if GlobalScript.session_time>0:
		%Timer.start(GlobalScript.session_time)
	else:
		%Timer.start(30.0)
func _process(delta: float) -> void:
	var time_left: float = %Timer.time_left
	var seconds: int = (time_left)
	var milliseconds: int = int((time_left - seconds) *100)

	%TimerLabel.text = "%02d:%02d" % [seconds, milliseconds]
	
func _on_minigame_timeout() -> void:
	%"Level Label".text = "TIME UP"
	GlobalScript.game_running = false
	get_tree().paused = true
	await get_tree().create_timer(1.0, true, false, true).timeout
	get_tree().change_scene_to_file("res://Scenes/level_screen.tscn")

func _add_coins() -> void:
	temp_coins+=1
	if has_node("HUD"):
		$HUD.update_coins_display
