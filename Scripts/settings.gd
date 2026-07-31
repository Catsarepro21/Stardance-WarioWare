extends Node2D

func _ready() -> void:
	# Pull existing values from the actual GlobalScript Autoload
	%Music_Slider.value = GlobalScript.music_volume
	%SFX_Slider.value = GlobalScript.sfx_volume
	%"FullScreen Checkbox".button_pressed = GlobalScript.fullscreen

func _on_music_slider_value_changed(value: float) -> void:
	GlobalScript.music_volume = value

func _on_SFX_slider_value_changed(value: float) -> void:
	GlobalScript.sfx_volume = value

func _on_full_screen_checkbox_toggled(toggled_on: bool) -> void:
	GlobalScript.fullscreen = toggled_on
	print("Fullscreen toggled")
	
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Title_Screen.tscn")
