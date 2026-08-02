extends Node

var lives: int = 3
var session_time: float = 0.00
var coins: int = 0
var music_volume: int = 50
var sfx_volume: int = 50 
var time_elapsed: float = 0.00
var game_running: bool = false
var fullscreen: bool = false

var level_data: Dictionary = {
	"Platformer_Minigame_1": {"completed": false, "bonus_coin": false},
	"Dropper_Minigame": {"completed": false, "bonus_coin": false}
}

var music_player: AudioStreamPlayer
var sfx_player: AudioStreamPlayer

func _ready() -> void:
	music_player = AudioStreamPlayer.new()
	music_player.name = "MusicPlayer"
	add_child(music_player)
	
	sfx_player = AudioStreamPlayer.new()
	sfx_player.name = "SFXPlayer"
	add_child(sfx_player)
	
	_update_audio_volumes()
	_generate_and_play_bgm()

func set_music_volume(val: int) -> void:
	music_volume = clamp(val, 0, 100)
	_update_audio_volumes()

func set_sfx_volume(val: int) -> void:
	sfx_volume = clamp(val, 0, 100)
	_update_audio_volumes()

func _update_audio_volumes() -> void:
	if music_player:
		if music_volume <= 0:
			music_player.volume_db = -80.0
		else:
			music_player.volume_db = linear_to_db(float(music_volume) / 100.0)
	if sfx_player:
		if sfx_volume <= 0:
			sfx_player.volume_db = -80.0
		else:
			sfx_player.volume_db = linear_to_db(float(sfx_volume) / 100.0)

func play_sfx(sfx_name: String) -> void:
	if sfx_volume <= 0 or not sfx_player:
		return
	var stream: AudioStreamWAV = _generate_sfx_stream(sfx_name)
	if stream:
		sfx_player.stream = stream
		sfx_player.play()

func _generate_sfx_stream(sfx_name: String) -> AudioStreamWAV:
	var bytes = PackedByteArray()
	var sample_rate = 22050
	var duration = 0.15
	
	if sfx_name == "coin":
		duration = 0.2
		var total_samples = int(sample_rate * duration)
		var note1_samples = int(total_samples * 0.4)
		var period1 = sample_rate / 987.77
		var period2 = sample_rate / 1318.51
		for i in range(total_samples):
			var period = period1 if i < note1_samples else period2
			var phase = fmod(i, period) / period
			var s = 60.0 if phase < 0.5 else -60.0
			bytes.append(int(clampi(int(s), -128, 127)) & 0xFF)
	elif sfx_name == "jump":
		duration = 0.15
		var total_samples = int(sample_rate * duration)
		var phase_acc = 0.0
		for i in range(total_samples):
			var progress = float(i) / total_samples
			var freq = lerp(150.0, 500.0, progress)
			phase_acc += freq / sample_rate
			var phase = fmod(phase_acc, 1.0)
			var s = 50.0 if phase < 0.5 else -50.0
			bytes.append(int(clampi(int(s), -128, 127)) & 0xFF)
	elif sfx_name == "hurt":
		duration = 0.25
		var total_samples = int(sample_rate * duration)
		var phase_acc = 0.0
		for i in range(total_samples):
			var progress = float(i) / total_samples
			var freq = lerp(400.0, 80.0, progress)
			phase_acc += freq / sample_rate
			var phase = fmod(phase_acc, 1.0)
			var noise = randf_range(-20.0, 20.0)
			var s = (50.0 if phase < 0.5 else -50.0) + noise
			bytes.append(int(clampi(int(s), -128, 127)) & 0xFF)
	elif sfx_name == "click":
		duration = 0.05
		var total_samples = int(sample_rate * duration)
		var period = sample_rate / 800.0
		for i in range(total_samples):
			var phase = fmod(i, period) / period
			var s = 40.0 if phase < 0.5 else -40.0
			bytes.append(int(clampi(int(s), -128, 127)) & 0xFF)
	elif sfx_name == "win":
		duration = 0.4
		var total_samples = int(sample_rate * duration)
		var quarter = int(total_samples / 4.0)
		var freqs = [523.25, 659.25, 783.99, 1046.50]
		for i in range(total_samples):
			var idx = clampi(int(i / quarter), 0, 3)
			var period = sample_rate / freqs[idx]
			var phase = fmod(i, period) / period
			var s = 50.0 if phase < 0.5 else -50.0
			bytes.append(int(clampi(int(s), -128, 127)) & 0xFF)

	if bytes.size() == 0:
		return null
		
	var wav = AudioStreamWAV.new()
	wav.format = AudioStreamWAV.FORMAT_8_BITS
	wav.mix_rate = sample_rate
	wav.stereo = false
	wav.data = bytes
	return wav

func _generate_and_play_bgm() -> void:
	if not music_player:
		return
	var sample_rate = 22050
	var bpm = 140.0
	var beat_sec = 60.0 / bpm
	var note_dur = beat_sec * 0.5
	
	var melody_notes = [
		261.63, 329.63, 392.00, 523.25,
		349.23, 440.00, 523.25, 659.25,
		392.00, 493.88, 587.33, 698.46,
		523.25, 392.00, 329.63, 261.63,
		261.63, 329.63, 392.00, 523.25,
		349.23, 440.00, 523.25, 659.25,
		392.00, 523.25, 659.25, 783.99,
		1046.50, 783.99, 523.25, 392.00
	]
	var bass_notes = [
		130.81, 130.81, 130.81, 130.81,
		174.61, 174.61, 174.61, 174.61,
		196.00, 196.00, 196.00, 196.00,
		130.81, 130.81, 130.81, 130.81,
		130.81, 130.81, 130.81, 130.81,
		174.61, 174.61, 174.61, 174.61,
		196.00, 196.00, 196.00, 196.00,
		130.81, 130.81, 130.81, 130.81
	]
	
	var samples_per_note = int(sample_rate * note_dur)
	var total_samples = samples_per_note * melody_notes.size()
	var bytes = PackedByteArray()
	
	for n in range(melody_notes.size()):
		var m_freq = melody_notes[n]
		var b_freq = bass_notes[n]
		var m_period = sample_rate / m_freq
		var b_period = sample_rate / b_freq
		for s in range(samples_per_note):
			var m_phase = fmod(s, m_period) / m_period
			var b_phase = fmod(s, b_period) / b_period
			var m_val = 30.0 if m_phase < 0.25 else -30.0
			var b_val = 25.0 if b_phase < 0.5 else -25.0
			var mix = m_val + b_val
			bytes.append(int(clampi(int(mix), -128, 127)) & 0xFF)
			
	var wav = AudioStreamWAV.new()
	wav.format = AudioStreamWAV.FORMAT_8_BITS
	wav.mix_rate = sample_rate
	wav.stereo = false
	wav.data = bytes
	wav.loop_mode = AudioStreamWAV.LOOP_FORWARD
	wav.loop_end = total_samples
	
	music_player.stream = wav
	music_player.play()

func _process(delta: float) -> void:
	if not game_running or get_tree().paused:
		return
		
	time_elapsed += delta
	
	if lives <= 0:
		trigger_game_over()

func trigger_game_over() -> void:
	if get_tree().root.has_node("Game_Over_Screen"):
		return
	game_running = false 
	get_tree().paused = true
	
	var death_screen = preload("res://Scenes/game_over_screen.tscn").instantiate()
	death_screen.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().root.add_child(death_screen)

func get_formatted_time() -> String:
	var minutes: int = int(time_elapsed) / 60
	var seconds: int = int(time_elapsed) % 60
	return "%02d:%02d" % [minutes, seconds]

func add_coins(amount: int = 1) -> void:
	coins += amount
	
func lose_life(spawn_pos: Vector2 = Vector2.ZERO) -> void:
	lives -= 1
	play_sfx("hurt")
	var current_scene = get_tree().current_scene
	var player = get_tree().get_first_node_in_group("Player")
	
	if player and player.has_method("play_hurt_animation"):
		await player.play_hurt_animation() 
		
	if lives <= 0:
		trigger_game_over()
	elif player and current_scene:
		if spawn_pos != Vector2.ZERO:
			player.global_position = spawn_pos
		elif "spawn_position" in current_scene:
			player.global_position = current_scene.spawn_position
		if player is CharacterBody2D:
			player.velocity = Vector2.ZERO

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.is_echo():
		if event.keycode == KEY_K and game_running: 
			lives = 0
			trigger_game_over()

func complete_level(level_id: String, got_coin: bool) -> void:
	if level_data.has(level_id):
		level_data[level_id]["completed"] = true
		if got_coin:
			level_data[level_id]["bonus_coin"] = true
