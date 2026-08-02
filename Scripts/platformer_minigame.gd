extends Node2D

var temp_coins: int = 0
@onready var player: CharacterBody2D = $Player
var spawn_position: Vector2

func _ready() -> void:
	get_tree().paused = false
	temp_coins = 0
	if player:
		spawn_position = player.global_position
	var timer = find_child("Timer", true, false)
	if timer and timer is Timer:
		timer.stop()
		timer.wait_time = 30.0
		timer.start()
	_refresh_hud()

func _process(_delta: float) -> void:
	var timer = find_child("Timer", true, false)
	var labels = find_children("TimerLabel", "Label", true, false)
	if timer and timer is Timer and labels.size() > 0:
		var timer_label = labels[0]
		var time_left: float = timer.time_left
		var seconds: int = int(time_left)
		var milliseconds: int = int((time_left - seconds) * 100)
		timer_label.text = "%02d:%02d" % [seconds, milliseconds]

func _on_minigame_timeout() -> void:
	var level_lbl = find_child("Level Label", true, false)
	if level_lbl and level_lbl is Label:
		level_lbl.text = "TIME UP"
	GlobalScript.game_running = false
	get_tree().paused = true
	await get_tree().create_timer(1.0, true, false, true).timeout
	get_tree().paused = false
	GlobalScript.coins += temp_coins 
	get_tree().change_scene_to_file("res://Scenes/level_screen.tscn")

func add_coin() -> void:
	temp_coins += 1
	_refresh_hud()

func _refresh_hud() -> void:
	var hud_node = find_child("HUD", true, false)
	if hud_node and hud_node.has_method("update_coins_display"):
		hud_node.update_coins_display()
