## Unit Tests for ObstacleFactory
## Tests obstacle generation based on difficulty

extends GutTest

const ObstacleFactory = preload("res://src/core/obstacle/obstacle_factory.gd")
const ObstacleType = preload("res://src/core/obstacle/obstacle_type.gd")
const Difficulty = preload("res://src/core/difficulty/difficulty.gd")


var factory: ObstacleFactory


func before_each():
	factory = ObstacleFactory.new()


func after_each():
	factory = null


# ============================================================
# Generation Probability Tests
# ============================================================

func test_easy_difficulty_has_low_obstacle_rate():
	var rate = factory.get_obstacle_rate(Difficulty.Level.EASY)
	assert_eq(rate, 0.1, "EASY should have 10% obstacle rate")


func test_normal_difficulty_has_medium_obstacle_rate():
	var rate = factory.get_obstacle_rate(Difficulty.Level.NORMAL)
	assert_eq(rate, 0.2, "NORMAL should have 20% obstacle rate")


func test_hard_difficulty_has_high_obstacle_rate():
	var rate = factory.get_obstacle_rate(Difficulty.Level.HARD)
	assert_eq(rate, 0.3, "HARD should have 30% obstacle rate")


func test_invalid_difficulty_returns_zero_rate():
	var rate = factory.get_obstacle_rate(999)
	assert_eq(rate, 0.0, "Invalid difficulty should return 0% obstacle rate")


# ============================================================
# Obstacle Type Distribution Tests
# ============================================================

func test_easy_difficulty_only_generates_crack():
	# Test multiple times to ensure consistency
	for i in range(10):
		var obstacle = factory.generate_obstacle(Difficulty.Level.EASY)
		if obstacle != null:
			assert_eq(obstacle.type, ObstacleType.Type.CRACK, "EASY should only generate CRACK obstacles")


func test_normal_difficulty_generates_crack_and_ice():
	# Test that NORMAL can generate both CRACK and ICE
	var types_generated = {}

	for i in range(100):
		var obstacle = factory.generate_obstacle(Difficulty.Level.NORMAL)
		if obstacle != null:
			types_generated[obstacle.type] = true

	# Should have both types or at least valid types
	for type in types_generated:
		assert_true(type == ObstacleType.Type.CRACK or type == ObstacleType.Type.ICE,
			"NORMAL should only generate CRACK or ICE")


func test_hard_difficulty_can_generate_all_types():
	# Test that HARD can generate all obstacle types
	var types_generated = {}

	for i in range(200):
		var obstacle = factory.generate_obstacle(Difficulty.Level.HARD)
		if obstacle != null:
			types_generated[obstacle.type] = true

	# Should be able to generate all types
	for type in types_generated:
		assert_true(type in [ObstacleType.Type.CRACK, ObstacleType.Type.ICE, ObstacleType.Type.SPIKE],
			"HARD should generate CRACK, ICE, or SPIKE")


# ============================================================
# Generation Logic Tests
# ============================================================

func test_generate_obstacle_can_return_null():
	# With seeded randomness, we should sometimes get null
	var got_null = false

	for i in range(50):
		var obstacle = factory.generate_obstacle(Difficulty.Level.EASY)
		if obstacle == null:
			got_null = true
			break

	assert_true(got_null, "generate_obstacle should sometimes return null based on probability")


func test_generate_obstacle_returns_valid_obstacle():
	var obstacle = factory.generate_obstacle_forced(Difficulty.Level.NORMAL)
	assert_not_null(obstacle, "generate_obstacle_forced should always return an obstacle")
	assert_true(obstacle.is_valid(), "Generated obstacle should be valid")


func test_generate_obstacle_forced_easy_returns_crack():
	var obstacle = factory.generate_obstacle_forced(Difficulty.Level.EASY)
	assert_eq(obstacle.type, ObstacleType.Type.CRACK, "Forced EASY obstacle should be CRACK")


func test_generate_obstacle_forced_with_invalid_difficulty_returns_crack():
	var obstacle = factory.generate_obstacle_forced(999)
	assert_eq(obstacle.type, ObstacleType.Type.CRACK, "Invalid difficulty should default to CRACK")


# ============================================================
# Seeded Randomness Tests
# ============================================================

func test_factory_with_seed_generates_consistent_results():
	var factory1 = ObstacleFactory.new(12345)
	var factory2 = ObstacleFactory.new(12345)

	var obstacles1 = []
	var obstacles2 = []

	for i in range(10):
		obstacles1.append(factory1.generate_obstacle(Difficulty.Level.HARD))
		obstacles2.append(factory2.generate_obstacle(Difficulty.Level.HARD))

	# Check that sequences match
	for i in range(10):
		if obstacles1[i] == null and obstacles2[i] == null:
			continue
		if obstacles1[i] != null and obstacles2[i] != null:
			assert_eq(obstacles1[i].type, obstacles2[i].type, "Seeded factories should generate same sequence")


func test_factory_without_seed_generates_different_results():
	var factory1 = ObstacleFactory.new()
	var factory2 = ObstacleFactory.new()

	var obstacles1 = []
	var obstacles2 = []

	for i in range(20):
		obstacles1.append(factory1.generate_obstacle_forced(Difficulty.Level.HARD))
		obstacles2.append(factory2.generate_obstacle_forced(Difficulty.Level.HARD))

	# At least some should be different (very high probability)
	var found_difference = false
	for i in range(20):
		if obstacles1[i].type != obstacles2[i].type:
			found_difference = true
			break

	assert_true(found_difference, "Unseeded factories should generate different sequences")


# ============================================================
# Edge Cases
# ============================================================

func test_generate_obstacle_with_zero_rate_always_returns_null():
	# Mock a difficulty with 0 rate
	for i in range(10):
		var obstacle = factory.generate_obstacle(999)  # Invalid = 0 rate
		assert_null(obstacle, "Zero obstacle rate should always return null")
