## StairGenerator
## 계단 생성 로직을 담당하는 클래스
## Pure GDScript - No Godot Node dependencies

class_name StairGenerator

const ObstacleFactory = preload("res://src/core/obstacle/obstacle_factory.gd")

# ==================== Constants ====================

const MAX_CONSECUTIVE_SAME_DIRECTION = 5


# ==================== Internal State ====================

## Current stair index
var _current_index: int = 0

## Last generated direction
var _last_direction: int = -1

## Count of consecutive stairs with same direction
var _consecutive_count: int = 0

## Random number generator
var _rng: RandomNumberGenerator

## Obstacle factory for generating obstacles
var _obstacle_factory: ObstacleFactory

## Current difficulty level
var _current_difficulty: int = -1


# ==================== Constructor ====================

func _init() -> void:
	_rng = RandomNumberGenerator.new()
	_rng.randomize()
	_obstacle_factory = ObstacleFactory.new()


# ==================== Public Methods ====================

## Generate the next stair in the sequence
## Returns a new Stair instance
func generate_next_stair() -> Stair:
	var direction = _determine_next_direction()

	# Generate obstacle if difficulty is set
	var obstacle = null
	if _current_difficulty >= 0:
		obstacle = _obstacle_factory.generate_obstacle(_current_difficulty)

	var stair = Stair.new(direction, _current_index, obstacle)

	# Update internal state
	_update_state(direction)

	return stair


## Reset the generator to initial state
func reset() -> void:
	_current_index = 0
	_last_direction = -1
	_consecutive_count = 0


## Set random seed for reproducible generation
func set_random_seed(seed_value: int) -> void:
	_rng.seed = seed_value


## Set difficulty level for obstacle generation
func set_difficulty(difficulty: int) -> void:
	_current_difficulty = difficulty


# ==================== Private Methods ====================

## Determine the next direction based on history and randomness
func _determine_next_direction() -> int:
	# If we've reached max consecutive, force opposite direction
	if _consecutive_count >= MAX_CONSECUTIVE_SAME_DIRECTION:
		return _get_opposite_direction(_last_direction)

	# Otherwise, generate random direction
	return _rng.randi_range(Direction.Side.LEFT, Direction.Side.RIGHT)


## Get the opposite direction
func _get_opposite_direction(direction: int) -> int:
	if direction == Direction.Side.LEFT:
		return Direction.Side.RIGHT
	else:
		return Direction.Side.LEFT


## Update internal state after generating a stair
func _update_state(direction: int) -> void:
	# Check if same direction as last
	if direction == _last_direction:
		_consecutive_count += 1
	else:
		_consecutive_count = 1

	_last_direction = direction
	_current_index += 1
