extends Node2D

var heart_full: Texture2D = preload("res://Assets/Heart_Full.PNG")
var heart_empty: Texture2D = preload("res://Assets/Heart_Empty.png")
	
func _process(_delta: float) -> void:
	$"%TimerLabel".text = GlobalScript.get_formatted_time()
	$"%Coins Label".text = str(GlobalScript.coins)
	update_hearts()
	
func update_hearts() -> void:
	$"%Heart1".texture = heart_full if GlobalScript.lives >= 1 else heart_empty
	$"%Heart2".texture = heart_full if GlobalScript.lives >= 2 else heart_empty
	$"%Heart3".texture = heart_full if GlobalScript.lives >= 3 else heart_empty
