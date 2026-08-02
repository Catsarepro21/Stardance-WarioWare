extends Node2D

var heart_full: Texture2D = preload("res://Assets/Heart_Full.PNG")
var heart_empty: Texture2D = preload("res://Assets/Heart_Empty.png")

func _ready() -> void:
	update_coins_display()
	update_hearts()

func _process(_delta: float) -> void:
	var timer_label = find_child("TimerLabel", true, false)
	if timer_label and timer_label is Label:
		timer_label.text = GlobalScript.get_formatted_time()
	update_hearts()

func update_hearts() -> void:
	var h1 = find_child("Heart1", true, false)
	var h2 = find_child("Heart2", true, false)
	var h3 = find_child("Heart3", true, false)
	if h1 and h1 is TextureRect:
		h1.texture = heart_full if GlobalScript.lives >= 1 else heart_empty
	if h2 and h2 is TextureRect:
		h2.texture = heart_full if GlobalScript.lives >= 2 else heart_empty
	if h3 and h3 is TextureRect:
		h3.texture = heart_full if GlobalScript.lives >= 3 else heart_empty

func update_coins_display() -> void:
	var level = get_tree().current_scene
	var temp = 0
	if level and "temp_coins" in level:
		temp = level.temp_coins
	var coin_label = find_child("Coins Label", true, false)
	if coin_label and coin_label is Label:
		coin_label.text = str(GlobalScript.coins + temp)
