## Test: DifficultyConfig
## TDD RED Phase: 테스트를 먼저 작성하고, 실제 구현은 테스트가 실패한 후 진행합니다.

extends GutTest

var config: DifficultyConfig

func before_each():
	# Given: Create DifficultyConfig instance before each test
	config = DifficultyConfig.new()


# ==================== Input Timeout Tests ====================

func test_easy_difficulty_has_correct_input_timeout():
	# Given: DifficultyConfig instance
	# When: Get input timeout for EASY difficulty
	var timeout = config.get_input_timeout(Difficulty.Level.EASY)

	# Then: Should return 2.5 seconds
	assert_eq(timeout, 2.5, "Easy mode should have 2.5s input timeout")


func test_normal_difficulty_has_correct_input_timeout():
	# Given: DifficultyConfig instance
	# When: Get input timeout for NORMAL difficulty
	var timeout = config.get_input_timeout(Difficulty.Level.NORMAL)

	# Then: Should return 1.8 seconds
	assert_eq(timeout, 1.8, "Normal mode should have 1.8s input timeout")


func test_hard_difficulty_has_correct_input_timeout():
	# Given: DifficultyConfig instance
	# When: Get input timeout for HARD difficulty
	var timeout = config.get_input_timeout(Difficulty.Level.HARD)

	# Then: Should return 1.2 seconds
	assert_eq(timeout, 1.2, "Hard mode should have 1.2s input timeout")


# ==================== Scroll Speed Tests ====================

func test_easy_difficulty_has_correct_scroll_speed():
	# Given: DifficultyConfig instance
	# When: Get scroll speed for EASY difficulty
	var speed = config.get_scroll_speed(Difficulty.Level.EASY)

	# Then: Should return 1.0x multiplier
	assert_eq(speed, 1.0, "Easy mode should have 1.0x scroll speed")


func test_normal_difficulty_has_correct_scroll_speed():
	# Given: DifficultyConfig instance
	# When: Get scroll speed for NORMAL difficulty
	var speed = config.get_scroll_speed(Difficulty.Level.NORMAL)

	# Then: Should return 1.5x multiplier
	assert_eq(speed, 1.5, "Normal mode should have 1.5x scroll speed")


func test_hard_difficulty_has_correct_scroll_speed():
	# Given: DifficultyConfig instance
	# When: Get scroll speed for HARD difficulty
	var speed = config.get_scroll_speed(Difficulty.Level.HARD)

	# Then: Should return 2.0x multiplier
	assert_eq(speed, 2.0, "Hard mode should have 2.0x scroll speed")


# ==================== Obstacle Spawn Rate Tests ====================

func test_easy_difficulty_has_correct_obstacle_spawn_rate():
	# Given: DifficultyConfig instance
	# When: Get obstacle spawn rate for EASY difficulty
	var rate = config.get_obstacle_spawn_rate(Difficulty.Level.EASY)

	# Then: Should return 0.05 (5%)
	assert_eq(rate, 0.05, "Easy mode should have 5% obstacle spawn rate")


func test_normal_difficulty_has_correct_obstacle_spawn_rate():
	# Given: DifficultyConfig instance
	# When: Get obstacle spawn rate for NORMAL difficulty
	var rate = config.get_obstacle_spawn_rate(Difficulty.Level.NORMAL)

	# Then: Should return 0.15 (15%)
	assert_eq(rate, 0.15, "Normal mode should have 15% obstacle spawn rate")


func test_hard_difficulty_has_correct_obstacle_spawn_rate():
	# Given: DifficultyConfig instance
	# When: Get obstacle spawn rate for HARD difficulty
	var rate = config.get_obstacle_spawn_rate(Difficulty.Level.HARD)

	# Then: Should return 0.25 (25%)
	assert_eq(rate, 0.25, "Hard mode should have 25% obstacle spawn rate")


# ==================== Score Multiplier Tests ====================

func test_easy_difficulty_has_correct_score_multiplier():
	# Given: DifficultyConfig instance
	# When: Get score multiplier for EASY difficulty
	var multiplier = config.get_score_multiplier(Difficulty.Level.EASY)

	# Then: Should return 1.0x
	assert_eq(multiplier, 1.0, "Easy mode should have 1.0x score multiplier")


func test_normal_difficulty_has_correct_score_multiplier():
	# Given: DifficultyConfig instance
	# When: Get score multiplier for NORMAL difficulty
	var multiplier = config.get_score_multiplier(Difficulty.Level.NORMAL)

	# Then: Should return 1.5x
	assert_eq(multiplier, 1.5, "Normal mode should have 1.5x score multiplier")


func test_hard_difficulty_has_correct_score_multiplier():
	# Given: DifficultyConfig instance
	# When: Get score multiplier for HARD difficulty
	var multiplier = config.get_score_multiplier(Difficulty.Level.HARD)

	# Then: Should return 2.0x
	assert_eq(multiplier, 2.0, "Hard mode should have 2.0x score multiplier")


# ==================== Error Handling Tests ====================

func test_invalid_difficulty_returns_default_values():
	# Given: DifficultyConfig instance
	# When: Get config for invalid difficulty value
	var invalid_difficulty = 999

	# Then: Should return default/safe values (0.0)
	assert_eq(config.get_input_timeout(invalid_difficulty), 0.0, "Invalid difficulty should return 0.0 for timeout")
	assert_eq(config.get_scroll_speed(invalid_difficulty), 0.0, "Invalid difficulty should return 0.0 for scroll speed")
	assert_eq(config.get_obstacle_spawn_rate(invalid_difficulty), 0.0, "Invalid difficulty should return 0.0 for spawn rate")
	assert_eq(config.get_score_multiplier(invalid_difficulty), 0.0, "Invalid difficulty should return 0.0 for multiplier")
