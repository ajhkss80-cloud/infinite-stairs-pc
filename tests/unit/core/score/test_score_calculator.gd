## Test: ScoreCalculator
## TDD RED Phase: 테스트를 먼저 작성하고, 실제 구현은 테스트가 실패한 후 진행합니다.

extends GutTest

var calculator: ScoreCalculator

func before_each():
	# Given: Create ScoreCalculator instance before each test
	calculator = ScoreCalculator.new()


# ==================== Basic Score Tests ====================

func test_calculate_basic_score_for_single_stair():
	# Given: ScoreCalculator instance
	# When: Calculate score for 1 stair climbed
	var score = calculator.calculate_basic_score(1)

	# Then: Should return 10 points (1 stair × 10 points)
	assert_eq(score, 10, "1 stair should give 10 points")


func test_calculate_basic_score_for_multiple_stairs():
	# Given: ScoreCalculator instance
	# When: Calculate score for 5 stairs climbed
	var score = calculator.calculate_basic_score(5)

	# Then: Should return 50 points (5 stairs × 10 points)
	assert_eq(score, 50, "5 stairs should give 50 points")


func test_calculate_basic_score_for_zero_stairs():
	# Given: ScoreCalculator instance
	# When: Calculate score for 0 stairs
	var score = calculator.calculate_basic_score(0)

	# Then: Should return 0 points
	assert_eq(score, 0, "0 stairs should give 0 points")


func test_calculate_basic_score_for_negative_stairs_returns_zero():
	# Given: ScoreCalculator instance
	# When: Calculate score for negative stairs (invalid input)
	var score = calculator.calculate_basic_score(-5)

	# Then: Should return 0 points (error handling)
	assert_eq(score, 0, "Negative stairs should return 0 points")


# ==================== Combo Bonus Tests ====================

func test_calculate_combo_bonus_for_exact_10_consecutive():
	# Given: ScoreCalculator instance
	# When: Calculate combo bonus for exactly 10 consecutive successes
	var bonus = calculator.calculate_combo_bonus(10)

	# Then: Should return 50 bonus points
	assert_eq(bonus, 50, "10 consecutive should give 50 bonus points")


func test_calculate_combo_bonus_for_more_than_10_consecutive():
	# Given: ScoreCalculator instance
	# When: Calculate combo bonus for 15 consecutive successes
	var bonus = calculator.calculate_combo_bonus(15)

	# Then: Should return 50 bonus points
	assert_eq(bonus, 50, "15 consecutive should give 50 bonus points")


func test_calculate_combo_bonus_returns_zero_when_below_threshold():
	# Given: ScoreCalculator instance
	# When: Calculate combo bonus for 9 consecutive (below threshold)
	var bonus = calculator.calculate_combo_bonus(9)

	# Then: Should return 0 bonus points
	assert_eq(bonus, 0, "9 consecutive (below 10) should give no bonus")


func test_calculate_combo_bonus_for_zero_consecutive():
	# Given: ScoreCalculator instance
	# When: Calculate combo bonus for 0 consecutive
	var bonus = calculator.calculate_combo_bonus(0)

	# Then: Should return 0 bonus points
	assert_eq(bonus, 0, "0 consecutive should give no bonus")


func test_calculate_combo_bonus_for_negative_consecutive_returns_zero():
	# Given: ScoreCalculator instance
	# When: Calculate combo bonus for negative value (invalid input)
	var bonus = calculator.calculate_combo_bonus(-5)

	# Then: Should return 0 bonus points (error handling)
	assert_eq(bonus, 0, "Negative consecutive should return 0 bonus")


# ==================== Timing Bonus Tests ====================

func test_calculate_timing_bonus_for_perfect_timing():
	# Given: ScoreCalculator instance and 2.5s timeout
	# When: Input time is 1.0s (40% of timeout, within 80%)
	var bonus = calculator.calculate_timing_bonus(1.0, 2.5)

	# Then: Should return 5 bonus points
	assert_eq(bonus, 5, "Input within 80% of timeout should give 5 bonus points")


func test_calculate_timing_bonus_at_80_percent_threshold():
	# Given: ScoreCalculator instance and 2.5s timeout
	# When: Input time is exactly 2.0s (80% of timeout)
	var bonus = calculator.calculate_timing_bonus(2.0, 2.5)

	# Then: Should return 5 bonus points
	assert_eq(bonus, 5, "Input at exactly 80% should give 5 bonus points")


func test_calculate_timing_bonus_above_80_percent_returns_zero():
	# Given: ScoreCalculator instance and 2.5s timeout
	# When: Input time is 2.1s (84% of timeout, above 80%)
	var bonus = calculator.calculate_timing_bonus(2.1, 2.5)

	# Then: Should return 0 bonus points
	assert_eq(bonus, 0, "Input above 80% should give no bonus")


func test_calculate_timing_bonus_for_instant_input():
	# Given: ScoreCalculator instance
	# When: Input time is 0.0s (instant)
	var bonus = calculator.calculate_timing_bonus(0.0, 2.5)

	# Then: Should return 5 bonus points
	assert_eq(bonus, 5, "Instant input should give 5 bonus points")


func test_calculate_timing_bonus_for_invalid_timeout_returns_zero():
	# Given: ScoreCalculator instance
	# When: Timeout is 0 or negative (invalid)
	var bonus1 = calculator.calculate_timing_bonus(1.0, 0.0)
	var bonus2 = calculator.calculate_timing_bonus(1.0, -1.0)

	# Then: Should return 0 bonus points (error handling)
	assert_eq(bonus1, 0, "Invalid timeout (0) should return 0 bonus")
	assert_eq(bonus2, 0, "Invalid timeout (negative) should return 0 bonus")


# ==================== Difficulty Multiplier Tests ====================

func test_apply_difficulty_multiplier_easy():
	# Given: ScoreCalculator instance and base score of 100
	# When: Apply EASY difficulty multiplier (1.0x)
	var final_score = calculator.apply_difficulty_multiplier(100, Difficulty.Level.EASY)

	# Then: Should return 100 (100 × 1.0)
	assert_eq(final_score, 100, "Easy difficulty should multiply by 1.0x")


func test_apply_difficulty_multiplier_normal():
	# Given: ScoreCalculator instance and base score of 100
	# When: Apply NORMAL difficulty multiplier (1.5x)
	var final_score = calculator.apply_difficulty_multiplier(100, Difficulty.Level.NORMAL)

	# Then: Should return 150 (100 × 1.5)
	assert_eq(final_score, 150, "Normal difficulty should multiply by 1.5x")


func test_apply_difficulty_multiplier_hard():
	# Given: ScoreCalculator instance and base score of 100
	# When: Apply HARD difficulty multiplier (2.0x)
	var final_score = calculator.apply_difficulty_multiplier(100, Difficulty.Level.HARD)

	# Then: Should return 200 (100 × 2.0)
	assert_eq(final_score, 200, "Hard difficulty should multiply by 2.0x")


func test_apply_difficulty_multiplier_with_zero_score():
	# Given: ScoreCalculator instance and score of 0
	# When: Apply any difficulty multiplier
	var final_score = calculator.apply_difficulty_multiplier(0, Difficulty.Level.HARD)

	# Then: Should return 0
	assert_eq(final_score, 0, "Zero score should remain zero after multiplier")


func test_apply_difficulty_multiplier_invalid_difficulty_returns_zero():
	# Given: ScoreCalculator instance
	# When: Apply invalid difficulty value
	var final_score = calculator.apply_difficulty_multiplier(100, 999)

	# Then: Should return 0 (error handling)
	assert_eq(final_score, 0, "Invalid difficulty should return 0")


# ==================== Total Score Calculation Tests ====================

func test_calculate_total_score_with_all_bonuses():
	# Given: ScoreCalculator instance
	# When: Calculate total score with all bonuses
	#   - 10 stairs climbed = 100 points
	#   - 10 consecutive = 50 bonus
	#   - Perfect timing = 5 bonus
	#   - NORMAL difficulty = 1.5x
	var total = calculator.calculate_total_score(10, 10, 1.0, 2.5, Difficulty.Level.NORMAL)

	# Then: Should return (100 + 50 + 5) × 1.5 = 232.5
	assert_eq(total, 232.5, "Total score with all bonuses should be 232.5")


func test_calculate_total_score_without_bonuses():
	# Given: ScoreCalculator instance
	# When: Calculate total score without any bonuses
	#   - 5 stairs climbed = 50 points
	#   - 5 consecutive = no combo bonus
	#   - Slow timing = no timing bonus
	#   - EASY difficulty = 1.0x
	var total = calculator.calculate_total_score(5, 5, 2.4, 2.5, Difficulty.Level.EASY)

	# Then: Should return 50 × 1.0 = 50
	assert_eq(total, 50.0, "Total score without bonuses should be 50")


func test_calculate_total_score_hard_difficulty():
	# Given: ScoreCalculator instance
	# When: Calculate total with HARD difficulty
	#   - 20 stairs = 200 points
	#   - 20 consecutive = 50 bonus
	#   - No timing bonus
	#   - HARD difficulty = 2.0x
	var total = calculator.calculate_total_score(20, 20, 1.5, 1.2, Difficulty.Level.HARD)

	# Then: Should return (200 + 50) × 2.0 = 500
	assert_eq(total, 500.0, "Total score on HARD should be 500")
