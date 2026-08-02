extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -500.0
var is_hurt: bool = false
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
	if is_hurt:
		return

	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		GlobalScript.play_sfx("jump")

	var direction := Input.get_axis("Move_Left", "Move_Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	_update_animations(direction)
	move_and_slide()

func _update_animations(direction: float) -> void:
	if is_hurt:
		return

	var sprite = find_child("PlayerSprite", true, false)
	if not sprite or not (sprite is AnimatedSprite2D):
		return

	if direction > 0:
		sprite.flip_h = false
	elif direction < 0:
		sprite.flip_h = true

	if not is_on_floor():
		sprite.play("Jump")
	elif direction != 0:
		sprite.play("Run")
	else:
		sprite.play("IDLE")

func play_hurt_animation() -> void:
	is_hurt = true
	velocity = Vector2.ZERO
	var sprite = find_child("PlayerSprite", true, false)
	if sprite and sprite is AnimatedSprite2D:
		sprite.play("Hurt")
	await get_tree().create_timer(0.5, true, false, true).timeout
	if is_instance_valid(self):
		if sprite and sprite is AnimatedSprite2D:
			sprite.play("IDLE")
		is_hurt = false
