## GameController
## 게임 플로우를 제어하는 Application Layer 클래스
## Core Layer 컴포넌트들을 조합하여 게임 로직 실행

class_name GameController


# ==================== Dependencies (Core Layer) ====================

var _difficulty_config: DifficultyConfig
var _stair_generator: StairGenerator
var _score_calculator: ScoreCalculator
var _stair_validator: StairValidator
var _save_service: SaveService
var _sound_manager: Node  # SoundManager from Application Layer


# ==================== Game State ====================

var _current_difficulty: int = Difficulty.Level.NORMAL
var _current_stair: Stair = null
var _current_score: float = 0.0
var _stairs_climbed: int = 0
var _consecutive_success: int = 0
var _elapsed_time: float = 0.0
var _input_timeout: float = 0.0
var _is_game_over: bool = false
var _input_start_time: float = 0.0


# ==================== Constructor ====================

func _init() -> void:
	_difficulty_config = DifficultyConfig.new()
	_stair_generator = StairGenerator.new()
	_score_calculator = ScoreCalculator.new()
	_stair_validator = StairValidator.new()
	_save_service = SaveService.new()

	# Load SoundManager dynamically
	var SoundManager = load("res://src/application/services/sound_manager.gd")
	_sound_manager = SoundManager.new()


# ==================== Public Methods ====================

## Start a new game with specified difficulty
func start_game(difficulty: int) -> void:
	_current_difficulty = difficulty
	_input_timeout = _difficulty_config.get_input_timeout(difficulty)

	# Reset game state
	_current_score = 0.0
	_stairs_climbed = 0
	_consecutive_success = 0
	_elapsed_time = 0.0
	_input_start_time = 0.0
	_is_game_over = false

	# Reset generator and create first stair
	_stair_generator.reset()
	_stair_generator.set_difficulty(difficulty)
	_current_stair = _stair_generator.generate_next_stair()

	# Start background music
	_sound_manager.play_bgm("theme_music")


## Process player input
func process_input(input_direction: int) -> void:
	# Cannot process input if game is over
	if _is_game_over:
		return

	# Validate input
	var validation = _stair_validator.validate_input(input_direction, _current_stair)

	if not validation.success:
		# Wrong input - game over
		_is_game_over = true
		_sound_manager.play_sfx("wrong_step")
		return

	# Correct input - update state
	_stairs_climbed += 1
	_consecutive_success += 1

	# Check for obstacle on current stair
	var obstacle_penalty = 1.0
	if _current_stair.has_obstacle():
		var obstacle = _current_stair.obstacle

		# Check for game over obstacle (SPIKE)
		if obstacle.causes_game_over():
			_is_game_over = true
			_sound_manager.play_sfx("game_over")
			return

		# Check for combo break (ICE)
		if obstacle.breaks_combo():
			_consecutive_success = 0  # Reset combo

		# Apply score penalty (CRACK)
		obstacle_penalty = obstacle.get_score_penalty()

	# Play correct step sound
	_sound_manager.play_sfx("correct_step")

	# Check for combo milestone (every 10 consecutive successes)
	if _consecutive_success > 0 and _consecutive_success % 10 == 0:
		_sound_manager.play_sfx("combo_bonus")

	# Calculate score for this stair
	var stair_score = _score_calculator.calculate_total_score(
		_stairs_climbed,
		_consecutive_success,
		_elapsed_time,
		_input_timeout,
		_current_difficulty
	)

	# Apply obstacle penalty to score
	_current_score = stair_score * obstacle_penalty

	# Generate next stair
	_current_stair = _stair_generator.generate_next_stair()

	# Reset timer for next input
	_elapsed_time = 0.0


## Update game state (called every frame)
func update(delta: float) -> void:
	if _is_game_over:
		return

	_elapsed_time += delta

	# Check timeout
	if _elapsed_time >= _input_timeout:
		_is_game_over = true
		_sound_manager.play_sfx("game_over")


## Get current score
func get_current_score() -> float:
	return _current_score


## Check if game is over
func is_game_over() -> bool:
	return _is_game_over


## Get current stair
func get_current_stair() -> Stair:
	return _current_stair


## Get elapsed time since last input
func get_elapsed_time() -> float:
	return _elapsed_time


## Reset game to initial state
func reset() -> void:
	_current_score = 0.0
	_stairs_climbed = 0
	_consecutive_success = 0
	_elapsed_time = 0.0
	_is_game_over = false
	_current_stair = null


## Get high score for current difficulty
func get_high_score() -> float:
	return _save_service.get_high_score(_current_difficulty)


## Check if current score is a new high score
func is_new_high_score() -> bool:
	return _save_service.is_new_high_score(_current_difficulty, _current_score)


## Save current score if it's a new high score
## Returns true if saved, false otherwise
func save_if_high_score() -> bool:
	if is_new_high_score():
		_save_service.save_high_score(_current_difficulty, _current_score)
		return true
	return false


## Get sound manager for external access (e.g., UI sound effects)
func get_sound_manager():
	return _sound_manager


## Get consecutive success count (for UI combo display)
func get_consecutive_success() -> int:
	return _consecutive_success


## Get stairs climbed count
func get_stairs_climbed() -> int:
	return _stairs_climbed
