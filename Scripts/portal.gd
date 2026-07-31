extends Area2D

var _player_touching = false
@export var minigame_scene: PackedScene


func _ready() -> void:
	$Portal.frame = 0
	
func _unhandled_input(event: InputEvent) -> void:
		if _player_touching and event.is_action_pressed("Ability"):
			enter_portal()
func _on_body_entered(body:Node2D) -> void:
	if body.is_in_group("Player"):
		_player_touching = true
		$Portal.play("Open")
		
func _on_body_exited(body:Node2D) -> void:
	if body.is_in_group("Player"):
		_player_touching = false
		$Portal.play_backwards("Open")

func enter_portal() -> void:
	if minigame_scene:
		get_tree().change_scene_to_file("res://Scenes/platformer_minigame.tscn")
	else:
		print("Assign Game to Portal")
