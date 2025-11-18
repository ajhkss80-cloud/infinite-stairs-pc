## Integration Tests for SoundManager
## Tests sound playback, volume control, and mute functionality

extends GutTest

const SoundManager = preload("res://src/application/services/sound_manager.gd")
const Difficulty = preload("res://src/core/difficulty/difficulty.gd")

var sound_manager: SoundManager


func before_each():
	sound_manager = SoundManager.new()


func after_each():
	sound_manager.queue_free()
	sound_manager = null


# ============================================================
# Initialization Tests
# ============================================================

func test_sound_manager_initializes_with_default_volumes():
	assert_eq(sound_manager.get_sfx_volume(), 1.0, "SFX volume should default to 1.0")
	assert_eq(sound_manager.get_bgm_volume(), 0.7, "BGM volume should default to 0.7")


func test_sound_manager_initializes_unmuted():
	assert_false(sound_manager.is_muted(), "Should not be muted by default")


# ============================================================
# SFX Playback Tests
# ============================================================

func test_play_sfx_correct_step():
	var result = sound_manager.play_sfx("correct_step")
	assert_true(result, "Should successfully play correct_step SFX")


func test_play_sfx_wrong_step():
	var result = sound_manager.play_sfx("wrong_step")
	assert_true(result, "Should successfully play wrong_step SFX")


func test_play_sfx_game_over():
	var result = sound_manager.play_sfx("game_over")
	assert_true(result, "Should successfully play game_over SFX")


func test_play_sfx_combo_bonus():
	var result = sound_manager.play_sfx("combo_bonus")
	assert_true(result, "Should successfully play combo_bonus SFX")


func test_play_sfx_with_invalid_name_returns_false():
	var result = sound_manager.play_sfx("invalid_sound")
	assert_false(result, "Should return false for invalid sound name")


func test_play_sfx_multiple_simultaneously():
	# SFX should be able to play simultaneously (polyphonic)
	var result1 = sound_manager.play_sfx("correct_step")
	var result2 = sound_manager.play_sfx("combo_bonus")
	assert_true(result1, "First SFX should play")
	assert_true(result2, "Second SFX should play simultaneously")


# ============================================================
# BGM Playback Tests
# ============================================================

func test_play_bgm_theme_music():
	var result = sound_manager.play_bgm("theme_music")
	assert_true(result, "Should successfully play theme_music BGM")


func test_play_bgm_with_invalid_name_returns_false():
	var result = sound_manager.play_bgm("invalid_bgm")
	assert_false(result, "Should return false for invalid BGM name")


func test_stop_bgm():
	sound_manager.play_bgm("theme_music")
	sound_manager.stop_bgm()
	assert_false(sound_manager.is_bgm_playing(), "BGM should not be playing after stop")


func test_play_bgm_replaces_current_bgm():
	# Only one BGM should play at a time
	sound_manager.play_bgm("theme_music")
	var is_playing_first = sound_manager.is_bgm_playing()
	sound_manager.play_bgm("theme_music")  # Play same or different BGM
	assert_true(is_playing_first, "First BGM should have started")
	assert_true(sound_manager.is_bgm_playing(), "New BGM should be playing")


# ============================================================
# Volume Control Tests
# ============================================================

func test_set_sfx_volume():
	sound_manager.set_sfx_volume(0.5)
	assert_eq(sound_manager.get_sfx_volume(), 0.5, "SFX volume should be set to 0.5")


func test_set_sfx_volume_clamps_to_zero():
	sound_manager.set_sfx_volume(-0.5)
	assert_eq(sound_manager.get_sfx_volume(), 0.0, "SFX volume should clamp to 0.0")


func test_set_sfx_volume_clamps_to_one():
	sound_manager.set_sfx_volume(1.5)
	assert_eq(sound_manager.get_sfx_volume(), 1.0, "SFX volume should clamp to 1.0")


func test_set_bgm_volume():
	sound_manager.set_bgm_volume(0.3)
	assert_eq(sound_manager.get_bgm_volume(), 0.3, "BGM volume should be set to 0.3")


func test_set_bgm_volume_clamps_to_zero():
	sound_manager.set_bgm_volume(-0.5)
	assert_eq(sound_manager.get_bgm_volume(), 0.0, "BGM volume should clamp to 0.0")


func test_set_bgm_volume_clamps_to_one():
	sound_manager.set_bgm_volume(1.5)
	assert_eq(sound_manager.get_bgm_volume(), 1.0, "BGM volume should clamp to 1.0")


# ============================================================
# Mute Functionality Tests
# ============================================================

func test_set_mute_true():
	sound_manager.set_mute(true)
	assert_true(sound_manager.is_muted(), "Should be muted")


func test_set_mute_false():
	sound_manager.set_mute(true)
	sound_manager.set_mute(false)
	assert_false(sound_manager.is_muted(), "Should be unmuted")


func test_play_sfx_when_muted_returns_false():
	sound_manager.set_mute(true)
	var result = sound_manager.play_sfx("correct_step")
	assert_false(result, "Should not play SFX when muted")


func test_play_bgm_when_muted_returns_false():
	sound_manager.set_mute(true)
	var result = sound_manager.play_bgm("theme_music")
	assert_false(result, "Should not play BGM when muted")


# ============================================================
# Edge Cases
# ============================================================

func test_stop_bgm_when_not_playing():
	# Should not crash when stopping BGM that's not playing
	sound_manager.stop_bgm()
	assert_false(sound_manager.is_bgm_playing(), "BGM should not be playing")


func test_play_sfx_with_empty_string():
	var result = sound_manager.play_sfx("")
	assert_false(result, "Should return false for empty string")


func test_play_bgm_with_empty_string():
	var result = sound_manager.play_bgm("")
	assert_false(result, "Should return false for empty string")
