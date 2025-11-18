## Test: StairValidator
## TDD RED Phase: 테스트를 먼저 작성하고, 실제 구현은 테스트가 실패한 후 진행합니다.

extends GutTest

var validator: StairValidator

func before_each():
	# Given: Create StairValidator instance before each test
	validator = StairValidator.new()


# ==================== Correct Input Validation Tests ====================

func test_validates_correct_left_input():
	# Given: StairValidator instance and LEFT stair
	var stair = Stair.new(Direction.Side.LEFT, 0)

	# When: Validate LEFT input
	var result = validator.validate_input(Direction.Side.LEFT, stair)

	# Then: Should return success
	assert_true(result.success, "LEFT input on LEFT stair should be valid")
	assert_eq(result.error, "", "Should have no error message")


func test_validates_correct_right_input():
	# Given: StairValidator instance and RIGHT stair
	var stair = Stair.new(Direction.Side.RIGHT, 0)

	# When: Validate RIGHT input
	var result = validator.validate_input(Direction.Side.RIGHT, stair)

	# Then: Should return success
	assert_true(result.success, "RIGHT input on RIGHT stair should be valid")
	assert_eq(result.error, "", "Should have no error message")


# ==================== Wrong Input Validation Tests ====================

func test_invalidates_wrong_input_left_stair_right_input():
	# Given: StairValidator instance and LEFT stair
	var stair = Stair.new(Direction.Side.LEFT, 0)

	# When: Validate RIGHT input (wrong)
	var result = validator.validate_input(Direction.Side.RIGHT, stair)

	# Then: Should return failure
	assert_false(result.success, "RIGHT input on LEFT stair should be invalid")
	assert_ne(result.error, "", "Should have error message")


func test_invalidates_wrong_input_right_stair_left_input():
	# Given: StairValidator instance and RIGHT stair
	var stair = Stair.new(Direction.Side.RIGHT, 0)

	# When: Validate LEFT input (wrong)
	var result = validator.validate_input(Direction.Side.LEFT, stair)

	# Then: Should return failure
	assert_false(result.success, "LEFT input on RIGHT stair should be invalid")
	assert_ne(result.error, "", "Should have error message")


# ==================== Invalid Input Tests ====================

func test_returns_error_for_invalid_input_direction():
	# Given: StairValidator instance and valid stair
	var stair = Stair.new(Direction.Side.LEFT, 0)

	# When: Validate invalid input direction (999)
	var result = validator.validate_input(999, stair)

	# Then: Should return failure
	assert_false(result.success, "Invalid input direction should fail")
	assert_ne(result.error, "", "Should have error message about invalid input")


func test_returns_error_for_null_stair():
	# Given: StairValidator instance
	# When: Validate with null stair
	var result = validator.validate_input(Direction.Side.LEFT, null)

	# Then: Should return failure
	assert_false(result.success, "Null stair should fail validation")
	assert_ne(result.error, "", "Should have error message about null stair")


# ==================== Result Structure Tests ====================

func test_result_contains_success_and_error_fields():
	# Given: StairValidator instance and stair
	var stair = Stair.new(Direction.Side.LEFT, 0)

	# When: Validate input
	var result = validator.validate_input(Direction.Side.LEFT, stair)

	# Then: Result should have required fields
	assert_true(result.has("success"), "Result should have 'success' field")
	assert_true(result.has("error"), "Result should have 'error' field")
