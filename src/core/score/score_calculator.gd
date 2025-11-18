## ScoreCalculator
## 점수 계산 로직을 담당하는 클래스
## Pure GDScript - No Godot Node dependencies

class_name ScoreCalculator

# ==================== Constants ====================

const POINTS_PER_STAIR = 10
const COMBO_THRESHOLD = 10
const COMBO_BONUS_POINTS = 50
const TIMING_BONUS_POINTS = 5
const TIMING_THRESHOLD_PERCENT = 0.8


# ==================== Public Methods ====================

## Calculate basic score based on number of stairs climbed
## Returns 0 for invalid input (negative stairs)
func calculate_basic_score(stairs_climbed: int) -> int:
	# Error-first: handle invalid input
	if stairs_climbed < 0:
		return 0

	return stairs_climbed * POINTS_PER_STAIR


## Calculate combo bonus for consecutive successful stairs
## Returns 50 points if consecutive >= 10, otherwise 0
## Returns 0 for invalid input (negative consecutive)
func calculate_combo_bonus(consecutive_success: int) -> int:
	# Error-first: handle invalid input
	if consecutive_success < 0:
		return 0

	# Check threshold
	if consecutive_success >= COMBO_THRESHOLD:
		return COMBO_BONUS_POINTS

	return 0


## Calculate timing bonus for fast input
## Returns 5 points if input_time <= 80% of timeout, otherwise 0
## Returns 0 for invalid timeout (0 or negative)
func calculate_timing_bonus(input_time: float, timeout: float) -> int:
	# Error-first: handle invalid timeout
	if timeout <= 0.0:
		return 0

	# Calculate timing threshold (80% of timeout)
	var threshold = timeout * TIMING_THRESHOLD_PERCENT

	# Check if input is within threshold
	if input_time <= threshold:
		return TIMING_BONUS_POINTS

	return 0


## Apply difficulty multiplier to base score
## Returns 0 for invalid difficulty
func apply_difficulty_multiplier(base_score: float, difficulty: int) -> float:
	# Get multiplier from DifficultyConfig
	var config = DifficultyConfig.new()
	var multiplier = config.get_score_multiplier(difficulty)

	# Error-first: if multiplier is 0 (invalid difficulty), return 0
	if multiplier == 0.0:
		return 0.0

	return base_score * multiplier


## Calculate total score with all components
## Parameters:
##   - stairs_climbed: Number of stairs successfully climbed
##   - consecutive_success: Number of consecutive successful climbs
##   - input_time: Time taken for input (seconds)
##   - timeout: Maximum allowed input time (seconds)
##   - difficulty: Difficulty level (Difficulty.Level enum)
func calculate_total_score(
	stairs_climbed: int,
	consecutive_success: int,
	input_time: float,
	timeout: float,
	difficulty: int
) -> float:
	# Calculate individual components
	var basic_score = calculate_basic_score(stairs_climbed)
	var combo_bonus = calculate_combo_bonus(consecutive_success)
	var timing_bonus = calculate_timing_bonus(input_time, timeout)

	# Sum all components
	var total_before_multiplier = basic_score + combo_bonus + timing_bonus

	# Apply difficulty multiplier
	var final_score = apply_difficulty_multiplier(total_before_multiplier, difficulty)

	return final_score
