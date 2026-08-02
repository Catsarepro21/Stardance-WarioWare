extends Node2D

var temp_coins: int = 0
var is_game_over: bool = false
var coin_spawned: bool = false

@export var timer_node: Timer
@export var timer_label: Label
@export var level_label: Label
@export var exit_flag: Node2D
@export var coin_node: Node2D

@export var coin_drop_delay: float = 1.0

func _ready() -> void:
	get_tree().paused = false
	is_game_over = false
	coin_spawned = false
	temp_coins = 0

	if exit_flag:
		exit_flag.visible = false
		if "monitoring" in exit_flag:
			exit_flag.monitoring = false

	if coin_node:
		coin_node.visible = false
		if coin_node is RigidBody2D:
			coin_node.freeze = true

	if timer_node:
		timer_node.stop()
		timer_node.wait_time = 30.0
		timer_node.one_shot = true
		if timer_node.timeout.is_connected(_on_minigame_timeout):
			timer_node.timeout.disconnect(_on_minigame_timeout)
		timer_node.timeout.connect(_on_minigame_timeout)
		timer_node.start()
		
	_refresh_hud()

func _process(_delta: float) -> void:
	if is_game_over:
		return

	if timer_node and timer_label:
		if timer_node.is_stopped():
			return
			
		var time_left: float = timer_node.time_left
		var seconds: int = int(time_left)
		var milliseconds: int = int((time_left - seconds) * 100)
		timer_label.text = "%02d:%02d" % [seconds, milliseconds]

		if not coin_spawned and time_left <= 15.0 and time_left > 0.0:
			coin_spawned = true
			_spawn_midgame_coin()

func add_coin() -> void:
	temp_coins += 1
	_refresh_hud()

func _refresh_hud() -> void:
	var hud_node = find_child("HUD", true, false)
	if hud_node and hud_node.has_method("update_coins_display"):
		hud_node.update_coins_display()

func _spawn_midgame_coin() -> void:
	if coin_node:
		coin_node.visible = true
		if coin_node is RigidBody2D:
			coin_node.freeze = false
	else:
		var spawner = find_child("Spawner", true, false)
		if spawner and spawner.has_method("spawn_coin"):
			spawner.spawn_coin()

func _on_minigame_timeout() -> void:
	is_game_over = true
	
	if timer_label:
		timer_label.text = "00:00"
		
	if level_label:
		level_label.text = "REACH THE EXIT!"
	
	if exit_flag:
		exit_flag.visible = true
		if "monitoring" in exit_flag:
			exit_flag.monitoring = true
		GlobalScript.play_sfx("win")
