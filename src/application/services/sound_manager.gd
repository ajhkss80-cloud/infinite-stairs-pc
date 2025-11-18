## SoundManager
## Application Layer - Service for managing game audio (SFX and BGM)
## Follows error-first design and provides volume/mute controls

extends Node

# Volume settings
var _sfx_volume: float = 1.0
var _bgm_volume: float = 0.7
var _is_muted: bool = false

# Audio players
var _bgm_player: AudioStreamPlayer
var _sfx_players: Array[AudioStreamPlayer] = []
const MAX_SFX_PLAYERS = 8  # Polyphonic SFX support

# Sound resource paths
const SOUND_PATHS = {
	"correct_step": "res://assets/sounds/sfx/correct_step.ogg",
	"wrong_step": "res://assets/sounds/sfx/wrong_step.ogg",
	"game_over": "res://assets/sounds/sfx/game_over.ogg",
	"combo_bonus": "res://assets/sounds/sfx/combo_bonus.ogg",
	"theme_music": "res://assets/sounds/bgm/theme_music.ogg"
}

# Loaded audio streams
var _loaded_streams: Dictionary = {}


func _init():
	_initialize_audio_players()
	_load_audio_streams()


func _initialize_audio_players():
	# Create BGM player
	_bgm_player = AudioStreamPlayer.new()
	_bgm_player.bus = "Master"
	add_child(_bgm_player)

	# Create SFX players for polyphonic playback
	for i in range(MAX_SFX_PLAYERS):
		var player = AudioStreamPlayer.new()
		player.bus = "Master"
		add_child(player)
		_sfx_players.append(player)


func _load_audio_streams():
	# Attempt to load all audio streams
	# If files don't exist yet, they'll be loaded when available
	for sound_name in SOUND_PATHS:
		var path = SOUND_PATHS[sound_name]
		if ResourceLoader.exists(path):
			_loaded_streams[sound_name] = load(path)


# ============================================================
# Public API - SFX Playback
# ============================================================

func play_sfx(sound_name: String) -> bool:
	# Error-first: validate inputs
	if sound_name == "":
		return false

	if _is_muted:
		return false

	if sound_name not in SOUND_PATHS:
		return false

	# Get audio stream
	var stream = _get_stream(sound_name)
	if stream == null:
		return false

	# Find available SFX player
	var player = _get_available_sfx_player()
	if player == null:
		return false

	# Play sound
	player.stream = stream
	player.volume_db = _linear_to_db(_sfx_volume)
	player.play()

	return true


func _get_available_sfx_player() -> AudioStreamPlayer:
	# Find a player that's not currently playing
	for player in _sfx_players:
		if not player.playing:
			return player

	# If all players are busy, use the first one (oldest sound gets cut off)
	return _sfx_players[0]


# ============================================================
# Public API - BGM Playback
# ============================================================

func play_bgm(bgm_name: String) -> bool:
	# Error-first: validate inputs
	if bgm_name == "":
		return false

	if _is_muted:
		return false

	if bgm_name not in SOUND_PATHS:
		return false

	# Get audio stream
	var stream = _get_stream(bgm_name)
	if stream == null:
		return false

	# Stop current BGM if playing
	if _bgm_player.playing:
		_bgm_player.stop()

	# Play new BGM
	_bgm_player.stream = stream
	_bgm_player.volume_db = _linear_to_db(_bgm_volume)
	_bgm_player.play()

	return true


func stop_bgm() -> void:
	if _bgm_player.playing:
		_bgm_player.stop()


func is_bgm_playing() -> bool:
	return _bgm_player.playing


# ============================================================
# Public API - Volume Control
# ============================================================

func set_sfx_volume(volume: float) -> void:
	_sfx_volume = clampf(volume, 0.0, 1.0)


func get_sfx_volume() -> float:
	return _sfx_volume


func set_bgm_volume(volume: float) -> void:
	_bgm_volume = clampf(volume, 0.0, 1.0)

	# Apply to current BGM if playing
	if _bgm_player.playing:
		_bgm_player.volume_db = _linear_to_db(_bgm_volume)


func get_bgm_volume() -> float:
	return _bgm_volume


# ============================================================
# Public API - Mute Control
# ============================================================

func set_mute(muted: bool) -> void:
	_is_muted = muted

	# Stop all audio when muted
	if _is_muted:
		stop_bgm()
		for player in _sfx_players:
			if player.playing:
				player.stop()


func is_muted() -> bool:
	return _is_muted


# ============================================================
# Private Helpers
# ============================================================

func _get_stream(sound_name: String):
	# Return cached stream if available
	if sound_name in _loaded_streams:
		return _loaded_streams[sound_name]

	# Try to load stream if it exists
	var path = SOUND_PATHS.get(sound_name, "")
	if path != "" and ResourceLoader.exists(path):
		var stream = load(path)
		_loaded_streams[sound_name] = stream
		return stream

	return null


func _linear_to_db(linear_volume: float) -> float:
	# Convert linear volume (0.0-1.0) to decibels
	# -80 dB is essentially silence
	if linear_volume <= 0.0:
		return -80.0
	return 20.0 * log(linear_volume) / log(10.0)
