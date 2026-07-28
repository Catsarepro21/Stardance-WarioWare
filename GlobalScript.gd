extends Node

#vars
var lives = 3
var coins = 0
var music_volume = 50
var sfx_volume =  50 
var time_elapsed = 0.00
var game_running = false

func _process(delta: float) -> void:
	if not game_running:
		return
		
	time_elapsed +=delta
	print(time_elapsed)
