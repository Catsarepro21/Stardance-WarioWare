extends Button

@export var action_name: String = "Move_Left"

var is_listening: bool = false

func _ready() -> void:
	pressed.connect(_on_button_pressed)
	update_button_text()

func update_button_text() -> void:
	var events = InputMap.action_get_events(action_name)
	if events.size() > 0:
		text = events[0].as_text().get_slice(" (", 0) 
	else:
		text = "Unbound"

func _on_button_pressed() -> void:
	GlobalScript.play_sfx("click")
	is_listening = true
	text = "Press Any Key..."

func _input(event: InputEvent) -> void:
	if not is_listening:
		return
		
	if event is InputEventKey and event.pressed and not event.is_echo():
		is_listening = false
		InputMap.action_erase_events(action_name)
		InputMap.action_add_event(action_name, event)
		update_button_text()
		GlobalScript.play_sfx("click")
		get_viewport().set_input_as_handled()
