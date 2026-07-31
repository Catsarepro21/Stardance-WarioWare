extends Node

# Vars
var lives = 3
var session_time = 0.00
var coins = 0
var music_volume = 50
var sfx_volume = 50 
var time_elapsed = 0.00
var game_running = true # Set to true if game starts immediately
var fullscreen = DisplayServer.window_get_mode()

# Timer and formatting:
func _process(delta: float) -> void:
	if not game_running or get_tree().paused:
		return
		
	time_elapsed += delta
	
	if lives <= 0:
		trigger_game_over()

func trigger_game_over() -> void:
	game_running = false
	get_tree().paused = true
	
	var death_screen = preload("res://Scenes/game_over_screen.tscn").instantiate()
	
	if death_screen is CanvasLayer:
		death_screen.layer = 100
		
	death_screen.process_mode = Node.PROCESS_MODE_ALWAYS
	
	get_tree().root.add_child(death_screen)
func get_formatted_time() -> String:
	var minutes: int = int(time_elapsed) / 60
	var seconds: int = int(time_elapsed) % 60
	return "%02d:%02d" % [minutes, seconds]

# Lives and Coins:
func addcoins(amount: int = 1) -> void:
	coins += amount
	
func lose_life() -> void:
	lives -= 1

# Kill Yourself:
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.is_echo():
		if event.keycode == KEY_K: 
			lives = 0
			print("Manually Triggered Death")
