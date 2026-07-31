extends Node2D

func update_coins_display() -> void:
	if has_node("HUD/CoinLabel"):
		$HUD/CoinLabel.text = str(GlobalScript.coins)
	elif has_node("%CoinLabel"):
		%CoinLabel.text = str(GlobalScript.coins)
	else:
		print("Still can't find it. Check the exact path in the Scene dock.")
