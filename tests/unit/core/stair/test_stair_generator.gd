## Test: StairGenerator
## TDD RED Phase: 테스트를 먼저 작성하고, 실제 구현은 테스트가 실패한 후 진행합니다.

extends GutTest

var generator: StairGenerator

func before_each():
	# Given: Create StairGenerator instance before each test
	generator = StairGenerator.new()


# ==================== Basic Generation Tests ====================

func test_generates_first_stair():
	# Given: StairGenerator instance
	# When: Generate first stair
	var stair = generator.generate_next_stair()

	# Then: Should return a valid Stair object
	assert_not_null(stair, "Should generate a stair")
	assert_true(stair is Stair, "Should return Stair instance")


func test_first_stair_has_valid_direction():
	# Given: StairGenerator instance
	# When: Generate first stair
	var stair = generator.generate_next_stair()

	# Then: Direction should be LEFT or RIGHT
	assert_true(
		stair.direction == Direction.Side.LEFT or stair.direction == Direction.Side.RIGHT,
		"First stair should have LEFT or RIGHT direction"
	)


func test_generates_stair_with_valid_direction():
	# Given: StairGenerator with some history
	generator.generate_next_stair()  # First stair

	# When: Generate next stair
	var stair = generator.generate_next_stair()

	# Then: Direction should be LEFT or RIGHT
	assert_true(
		stair.direction == Direction.Side.LEFT or stair.direction == Direction.Side.RIGHT,
		"Generated stair should have valid direction (LEFT or RIGHT)"
	)


func test_stair_index_increments():
	# Given: StairGenerator instance
	# When: Generate multiple stairs
	var stair1 = generator.generate_next_stair()
	var stair2 = generator.generate_next_stair()
	var stair3 = generator.generate_next_stair()

	# Then: Index should increment
	assert_eq(stair1.index, 0, "First stair should have index 0")
	assert_eq(stair2.index, 1, "Second stair should have index 1")
	assert_eq(stair3.index, 2, "Third stair should have index 2")


# ==================== Consecutive Direction Limit Tests ====================

func test_prevents_more_than_5_consecutive_same_directions():
	# Given: StairGenerator instance
	# When: Generate many stairs and track consecutive count
	var max_consecutive = 0
	var current_consecutive = 1
	var previous_direction = -1

	for i in range(1000):  # Generate many stairs to test the limit
		var stair = generator.generate_next_stair()

		if previous_direction == -1:
			previous_direction = stair.direction
		elif stair.direction == previous_direction:
			current_consecutive += 1
			max_consecutive = max(max_consecutive, current_consecutive)
		else:
			current_consecutive = 1
			previous_direction = stair.direction

	# Then: Should never exceed 5 consecutive same directions
	assert_lte(max_consecutive, 5, "Should not allow more than 5 consecutive same directions")


func test_forces_direction_change_after_5_consecutive():
	# Given: StairGenerator with forced sequence
	# Manually set up a scenario with 5 consecutive LEFT stairs
	generator._consecutive_count = 5
	generator._last_direction = Direction.Side.LEFT

	# When: Generate next stair
	var stair = generator.generate_next_stair()

	# Then: Must be RIGHT (opposite direction)
	assert_eq(stair.direction, Direction.Side.RIGHT, "After 5 consecutive LEFT, must generate RIGHT")


# ==================== Randomness Tests ====================

func test_randomness_produces_both_directions():
	# Given: StairGenerator instance
	# When: Generate many stairs
	var left_count = 0
	var right_count = 0

	for i in range(100):
		var stair = generator.generate_next_stair()
		if stair.direction == Direction.Side.LEFT:
			left_count += 1
		else:
			right_count += 1

	# Then: Both directions should appear at least once
	assert_gt(left_count, 0, "LEFT direction should appear at least once")
	assert_gt(right_count, 0, "RIGHT direction should appear at least once")


func test_randomness_produces_varied_patterns():
	# Given: StairGenerator instance
	# When: Generate stairs and track patterns
	var patterns = {}

	for i in range(50):
		var pattern = ""
		for j in range(5):
			var stair = generator.generate_next_stair()
			pattern += "L" if stair.direction == Direction.Side.LEFT else "R"

		patterns[pattern] = true

	# Then: Should have multiple different patterns (at least 3)
	assert_gte(patterns.size(), 3, "Should produce varied patterns (at least 3 different patterns)")


# ==================== Reset/State Tests ====================

func test_reset_clears_history():
	# Given: StairGenerator with some history
	for i in range(10):
		generator.generate_next_stair()

	# When: Reset the generator
	generator.reset()

	# Then: Next stair should be index 0
	var stair = generator.generate_next_stair()
	assert_eq(stair.index, 0, "After reset, first stair should have index 0")


func test_can_set_seed_for_reproducibility():
	# Given: Two generators with same seed
	var gen1 = StairGenerator.new()
	var gen2 = StairGenerator.new()

	gen1.set_random_seed(12345)
	gen2.set_random_seed(12345)

	# When: Generate stairs from both
	var stairs1 = []
	var stairs2 = []

	for i in range(10):
		stairs1.append(gen1.generate_next_stair().direction)
		stairs2.append(gen2.generate_next_stair().direction)

	# Then: Should produce identical sequences
	for i in range(10):
		assert_eq(stairs1[i], stairs2[i], "Same seed should produce same sequence at index " + str(i))
