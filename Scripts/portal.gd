extends Area2D

@export var minigame_scene: PackedScene
var _player_touching: bool = false
@export var level_id: String = "Platformer_Minigame_1"
@export var required_coins: int = 0
@export var requires_both_completed: bool = false

func _ready() -> void:
	var portal_anim = find_child("Portal", true, false)
	if portal_anim and portal_anim is AnimatedSprite2D:
		portal_anim.frame = 0
	update_portal_indicators()

func _unhandled_input(event: InputEvent) -> void:
	if _player_touching and event.is_action_pressed("Ability"):
		enter_portal()

func is_portal_unlocked() -> bool:
	if requires_both_completed:
		var p_done = GlobalScript.level_data.get("Platformer_Minigame_1", {}).get("completed", false)
		var d_done = GlobalScript.level_data.get("Dropper_Minigame", {}).get("completed", false)
		if not (p_done and d_done):
			return false
	if required_coins > 0 and GlobalScript.coins < required_coins:
		return false
	return true

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		_player_touching = true
		if is_portal_unlocked():
			var portal_anim = find_child("Portal", true, false)
			if portal_anim and portal_anim is AnimatedSprite2D:
				portal_anim.play("Open")

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		_player_touching = false
		var portal_anim = find_child("Portal", true, false)
		if portal_anim and portal_anim is AnimatedSprite2D:
			portal_anim.play_backwards("Open")

func enter_portal() -> void:
	if not is_portal_unlocked():
		return
	if minigame_scene:
		get_tree().paused = false
		GlobalScript.game_running = true
		get_tree().change_scene_to_packed(minigame_scene)

func update_portal_indicators() -> void:
	if requires_both_completed:
		var unlocked = is_portal_unlocked()
		visible = unlocked
		return
	var flag_sprite = find_child("LevelCompleted", true, false)
	var coin_sprite = find_child("CoinCollected", true, false)
	if GlobalScript.level_data.has(level_id):
		var data: Dictionary = GlobalScript.level_data[level_id]
		if flag_sprite and flag_sprite is Sprite2D:
			flag_sprite.visible = data.get("completed", false)
		if coin_sprite and coin_sprite is Sprite2D:
			coin_sprite.visible = data.get("bonus_coin", false)
