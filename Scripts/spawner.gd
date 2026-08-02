extends Node2D

@export var block_scene: PackedScene
@export var coin_scene: PackedScene

@export var drop_time_seconds: float = 10.0  
@export var spawn_interval: float = 1.0    

@export var min_x: float = 50.0
@export var max_x: float = 1100.0

@onready var marker_2d: Marker2D = $Marker2D

var _timer: Timer

func _ready() -> void:
	_timer = Timer.new()
	_timer.wait_time = spawn_interval
	_timer.autostart = true
	_timer.timeout.connect(spawn_block)
	add_child(_timer)

func spawn_block() -> void:
	if block_scene and marker_2d:
		var block = block_scene.instantiate()
		var spawn_x = randf_range(min_x, max_x)
		var spawn_y = marker_2d.global_position.y
		block.global_position = Vector2(spawn_x, spawn_y)
		get_parent().add_child(block)

func spawn_coin() -> void:
	if coin_scene and marker_2d:
		var coin = coin_scene.instantiate()
		var spawn_x = randf_range(min_x + 100.0, max_x - 100.0)
		var spawn_y = marker_2d.global_position.y
		if "is_falling" in coin:
			coin.is_falling = true
		coin.global_position = Vector2(spawn_x, spawn_y)
		get_parent().add_child(coin)
