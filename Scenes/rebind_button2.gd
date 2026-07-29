extends Button

# Set the target action in the Inspector (e.g., "microgame_action")
@export var action_name: String = "Move_Right"

var is_listening: bool = false

func _ready() -> void:
	# Wire up button press
	pressed.connect(_on_button_pressed)
	# Display the current mapped key on load
	update_button_text()

func update_button_text() -> void:
	var events = InputMap.action_get_events(action_name)
	if events.size() > 0:
		# Grabs human-readable name (e.g., "Space", "W", "Escape")
		text = events[0].as_text().get_slice(" (", 0) 
	else:
		text = "Unbound"

func _on_button_pressed() -> void:
	is_listening = true
	text = "Press Any Key..."

func _input(event: InputEvent) -> void:
	if not is_listening:
		return
		
	# Ignore mouse movement/clicks so hovering or focusing doesn't count as a keybind
	if event is InputEventKey and event.pressed and not event.is_echo():
		# Stop listening
		is_listening = false
		
		# 1. Clear old bindings for this action
		InputMap.action_erase_events(action_name)
		
		# 2. Add the new hardware key
		InputMap.action_add_event(action_name, event)
		
		# 3. Update button display text
		update_button_text()
		
		# Prevent the key press from triggering other UI menus in the same frame
		get_viewport().set_input_as_handled()
