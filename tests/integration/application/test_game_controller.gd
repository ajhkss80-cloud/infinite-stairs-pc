## Test: GameController
## Integration Test: GameController와 Core Layer 컴포넌트 통합 테스트

extends GutTest

var controller: GameController

func before_each():
	# Given: Create GameController instance before each test
	controller = GameController.new()


# ==================== Game Start Tests ====================

func test_start_game_initializes_with_difficulty():
	# Given: GameController instance
	# When: Start game with NORMAL difficulty
	controller.start_game(Difficulty.Level.NORMAL)

	# Then: Game should be initialized and not over
	assert_false(controller.is_game_over(), "Game should not be over after start")
	assert_not_null(controller.get_current_stair(), "Should have current stair")
	assert_eq(controller.get_current_score(), 0, "Initial score should be 0")


func test_start_game_creates_first_stair():
	# Given: GameController instance
	# When: Start game
	controller.start_game(Difficulty.Level.EASY)

	# Then: Should have a current stair
	var stair = controller.get_current_stair()
	assert_not_null(stair, "Should have first stair")
	assert_true(
		stair.direction == Direction.Side.LEFT or stair.direction == Direction.Side.RIGHT,
		"First stair should have valid direction"
	)


# ==================== Input Processing Tests ====================

func test_process_correct_input_increases_score():
	# Given: Game started with known seed
	controller.start_game(Difficulty.Level.EASY)
	var current_stair = controller.get_current_stair()
	var initial_score = controller.get_current_score()

	# When: Process correct input
	controller.process_input(current_stair.direction)

	# Then: Score should increase
	assert_gt(controller.get_current_score(), initial_score, "Score should increase after correct input")


func test_process_correct_input_generates_next_stair():
	# Given: Game started
	controller.start_game(Difficulty.Level.EASY)
	var first_stair = controller.get_current_stair()

	# When: Process correct input
	controller.process_input(first_stair.direction)

	# Then: Should have new stair
	var second_stair = controller.get_current_stair()
	assert_not_null(second_stair, "Should have next stair")
	assert_ne(second_stair.index, first_stair.index, "Should be different stair")


func test_process_wrong_input_triggers_game_over():
	# Given: Game started with known stair direction
	controller.start_game(Difficulty.Level.EASY)
	var current_stair = controller.get_current_stair()
	var wrong_input = Direction.Side.RIGHT if current_stair.direction == Direction.Side.LEFT else Direction.Side.LEFT

	# When: Process wrong input
	controller.process_input(wrong_input)

	# Then: Game should be over
	assert_true(controller.is_game_over(), "Game should be over after wrong input")


# ==================== Time Update Tests ====================

func test_update_increases_elapsed_time():
	# Given: Game started
	controller.start_game(Difficulty.Level.EASY)
	var initial_time = controller.get_elapsed_time()

	# When: Update with delta time
	controller.update(0.1)

	# Then: Elapsed time should increase
	assert_gt(controller.get_elapsed_time(), initial_time, "Elapsed time should increase")


func test_timeout_triggers_game_over():
	# Given: Game started with EASY difficulty (2.5s timeout)
	controller.start_game(Difficulty.Level.EASY)

	# When: Update with time exceeding timeout
	controller.update(3.0)

	# Then: Game should be over
	assert_true(controller.is_game_over(), "Game should be over after timeout")


# ==================== Score Calculation Tests ====================

func test_consecutive_success_gives_combo_bonus():
	# Given: Game started with EASY difficulty
	controller.start_game(Difficulty.Level.EASY)

	# When: Successfully climb 10 stairs
	for i in range(10):
		var stair = controller.get_current_stair()
		controller.process_input(stair.direction)

	# Then: Score should include combo bonus
	# 10 stairs × 10 points = 100, plus 50 combo bonus = 150 (with 1.0x multiplier)
	assert_gte(controller.get_current_score(), 150, "Should have combo bonus after 10 stairs")


func test_timing_bonus_applied_for_fast_input():
	# Given: Game started
	controller.start_game(Difficulty.Level.EASY)
	var stair = controller.get_current_stair()

	# When: Process input quickly (within 80% of timeout)
	controller.update(0.5)  # Fast input
	controller.process_input(stair.direction)

	# Then: Should have timing bonus in score
	# Basic 10 points + 5 timing bonus = 15
	assert_gte(controller.get_current_score(), 15, "Should have timing bonus for fast input")


# ==================== Difficulty Settings Tests ====================

func test_hard_difficulty_has_shorter_timeout():
	# Given: Two controllers with different difficulties
	var easy_controller = GameController.new()
	var hard_controller = GameController.new()

	easy_controller.start_game(Difficulty.Level.EASY)
	hard_controller.start_game(Difficulty.Level.HARD)

	# When: Update both with same delta that should timeout HARD but not EASY
	# HARD timeout is 1.2s, EASY is 2.5s
	easy_controller.update(1.5)
	hard_controller.update(1.5)

	# Then: HARD should be over, EASY should not
	assert_false(easy_controller.is_game_over(), "EASY should not timeout at 1.5s")
	assert_true(hard_controller.is_game_over(), "HARD should timeout at 1.5s")


func test_difficulty_multiplier_applied_to_score():
	# Given: Game started with HARD difficulty (2.0x multiplier)
	controller.start_game(Difficulty.Level.HARD)
	var stair = controller.get_current_stair()

	# When: Process one correct input
	controller.process_input(stair.direction)

	# Then: Score should be multiplied
	# 10 points × 2.0 = 20
	assert_eq(controller.get_current_score(), 20, "HARD difficulty should apply 2.0x multiplier")


# ==================== Reset Tests ====================

func test_reset_clears_game_state():
	# Given: Game in progress with score
	controller.start_game(Difficulty.Level.NORMAL)
	var stair = controller.get_current_stair()
	controller.process_input(stair.direction)

	# When: Reset the game
	controller.reset()

	# Then: Should be back to initial state
	assert_eq(controller.get_current_score(), 0, "Score should be reset to 0")
	assert_false(controller.is_game_over(), "Game over should be reset")


# ==================== Edge Case Tests ====================

func test_cannot_process_input_when_game_over():
	# Given: Game that is over
	controller.start_game(Difficulty.Level.EASY)
	var stair = controller.get_current_stair()
	var wrong_input = Direction.Side.RIGHT if stair.direction == Direction.Side.LEFT else Direction.Side.LEFT
	controller.process_input(wrong_input)  # Trigger game over
	var score_when_over = controller.get_current_score()

	# When: Try to process input after game over
	controller.process_input(Direction.Side.LEFT)

	# Then: Score should not change
	assert_eq(controller.get_current_score(), score_when_over, "Score should not change when game is over")
