extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -500.0

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("Move_Left", "Move_Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	_update_animations(direction)
	move_and_slide()
	
func _update_animations(direction: float) -> void:
	if direction > 0:
		%PlayerSprite.flip_h = false
	elif  direction <0:
		%PlayerSprite.flip_h = true
	if not is_on_floor():
		%PlayerSprite.play("Jump")
	elif direction !=0:
		%PlayerSprite.play("Run")
	else:
		%PlayerSprite.play("IDLE")
