extends Node2D

func _ready() -> void:
	update_coins_display()
	for child in get_children():
		if child.has_method("update_portal_indicators"):
			child.update_portal_indicators()

func update_coins_display() -> void:
	var hud_node = find_child("HUD", true, false)
	if hud_node and hud_node.has_method("update_coins_display"):
		hud_node.update_coins_display()
