## DifficultyConfig
## 난이도별 게임 설정값을 관리하는 클래스
## Pure GDScript - No Godot dependencies

class_name DifficultyConfig

# ==================== Constants ====================

# Input timeout values (seconds)
const INPUT_TIMEOUTS = {
	Difficulty.Level.EASY: 2.5,
	Difficulty.Level.NORMAL: 1.8,
	Difficulty.Level.HARD: 1.2
}

# Scroll speed multipliers
const SCROLL_SPEEDS = {
	Difficulty.Level.EASY: 1.0,
	Difficulty.Level.NORMAL: 1.5,
	Difficulty.Level.HARD: 2.0
}

# Obstacle spawn rates (0.0 to 1.0)
const OBSTACLE_SPAWN_RATES = {
	Difficulty.Level.EASY: 0.05,    # 5%
	Difficulty.Level.NORMAL: 0.15,  # 15%
	Difficulty.Level.HARD: 0.25     # 25%
}

# Score multipliers
const SCORE_MULTIPLIERS = {
	Difficulty.Level.EASY: 1.0,
	Difficulty.Level.NORMAL: 1.5,
	Difficulty.Level.HARD: 2.0
}


# ==================== Public Methods ====================

## Get input timeout for specified difficulty level
## Returns 0.0 if difficulty is invalid
func get_input_timeout(difficulty: int) -> float:
	return INPUT_TIMEOUTS.get(difficulty, 0.0)


## Get scroll speed multiplier for specified difficulty level
## Returns 0.0 if difficulty is invalid
func get_scroll_speed(difficulty: int) -> float:
	return SCROLL_SPEEDS.get(difficulty, 0.0)


## Get obstacle spawn rate for specified difficulty level
## Returns 0.0 if difficulty is invalid
func get_obstacle_spawn_rate(difficulty: int) -> float:
	return OBSTACLE_SPAWN_RATES.get(difficulty, 0.0)


## Get score multiplier for specified difficulty level
## Returns 0.0 if difficulty is invalid
func get_score_multiplier(difficulty: int) -> float:
	return SCORE_MULTIPLIERS.get(difficulty, 0.0)
