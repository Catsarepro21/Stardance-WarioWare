extends Node2D

func _ready() -> void:
	var music = find_child("Music_Slider", true, false)
	var sfx = find_child("SFX_Slider", true, false)
	var fs = find_child("FullScreen Checkbox", true, false)
	if music and music is Range:
		music.value = GlobalScript.music_volume
	if sfx and sfx is Range:
		sfx.value = GlobalScript.sfx_volume
	if fs and fs is CheckBox:
		fs.button_pressed = GlobalScript.fullscreen

func _on_music_slider_value_changed(value: float) -> void:
	GlobalScript.set_music_volume(int(value))

func _on_SFX_slider_value_changed(value: float) -> void:
	GlobalScript.set_sfx_volume(int(value))

func _on_full_screen_checkbox_toggled(toggled_on: bool) -> void:
	GlobalScript.play_sfx("click")
	GlobalScript.fullscreen = toggled_on
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_texture_button_pressed() -> void:
	GlobalScript.play_sfx("click")
	get_tree().change_scene_to_file("res://Scenes/Title_Screen.tscn")
