extends RigidBody2D

@export var fall_speed: float = 200.0
@export var trigger_delay: float = 0.5  

var is_falling: bool = false

func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 4
	var timer = get_tree().create_timer(trigger_delay)
	await timer.timeout
	if is_instance_valid(self):
		is_falling = true

func _physics_process(delta: float) -> void:
	if is_falling:
		position.y += fall_speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		GlobalScript.lose_life()
		var timer_node = get_tree().current_scene.get_node_or_null("Timer")
		if timer_node and timer_node is Timer:
			GlobalScript.session_time = timer_node.time_left
		queue_free()
		return
		
	if body.is_in_group("Ground"):
		queue_free()
