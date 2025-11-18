## ObstacleFactory
## Core Layer - Factory for generating obstacles based on difficulty
## Pure GDScript with seeded randomness support

class_name ObstacleFactory

const Obstacle = preload("res://src/core/obstacle/obstacle.gd")
const ObstacleType = preload("res://src/core/obstacle/obstacle_type.gd")
const Difficulty = preload("res://src/core/difficulty/difficulty.gd")

# Obstacle spawn rates per difficulty
const OBSTACLE_RATES = {
	Difficulty.Level.EASY: 0.1,    # 10% chance
	Difficulty.Level.NORMAL: 0.2,  # 20% chance
	Difficulty.Level.HARD: 0.3     # 30% chance
}

# Available obstacle types per difficulty
const OBSTACLE_TYPES_BY_DIFFICULTY = {
	Difficulty.Level.EASY: [ObstacleType.Type.CRACK],
	Difficulty.Level.NORMAL: [ObstacleType.Type.CRACK, ObstacleType.Type.ICE],
	Difficulty.Level.HARD: [ObstacleType.Type.CRACK, ObstacleType.Type.ICE, ObstacleType.Type.SPIKE]
}

var _rng: RandomNumberGenerator


# ============================================================
# Constructor
# ============================================================

func _init(seed_value: int = -1) -> void:
	_rng = RandomNumberGenerator.new()

	if seed_value >= 0:
		_rng.seed = seed_value
	else:
		_rng.randomize()


# ============================================================
# Public API
# ============================================================

## Returns the obstacle spawn rate for the given difficulty
func get_obstacle_rate(difficulty: int) -> float:
	return OBSTACLE_RATES.get(difficulty, 0.0)


## Generates an obstacle based on difficulty and spawn rate
## Returns null if no obstacle should spawn
func generate_obstacle(difficulty: int) -> Obstacle:
	# Error-first: check if difficulty is valid
	if difficulty not in OBSTACLE_RATES:
		return null

	# Check spawn rate
	var spawn_rate = get_obstacle_rate(difficulty)
	var roll = _rng.randf()

	if roll >= spawn_rate:
		return null  # No obstacle spawns

	# Generate obstacle type based on difficulty
	return _generate_obstacle_of_type(difficulty)


## Generates an obstacle without probability check (always returns an obstacle)
## Used for testing and guaranteed obstacle placement
func generate_obstacle_forced(difficulty: int) -> Obstacle:
	return _generate_obstacle_of_type(difficulty)


# ============================================================
# Private Helpers
# ============================================================

func _generate_obstacle_of_type(difficulty: int) -> Obstacle:
	# Get available obstacle types for this difficulty
	var available_types = OBSTACLE_TYPES_BY_DIFFICULTY.get(difficulty, [ObstacleType.Type.CRACK])

	# Select random type from available types
	var type_index = _rng.randi_range(0, available_types.size() - 1)
	var obstacle_type = available_types[type_index]

	return Obstacle.new(obstacle_type)
