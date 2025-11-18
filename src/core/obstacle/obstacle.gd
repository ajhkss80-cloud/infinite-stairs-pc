## Obstacle
## Core Layer - Data model representing an obstacle on a stair
## Pure GDScript - No Godot node dependencies

class_name Obstacle

const ObstacleType = preload("res://src/core/obstacle/obstacle_type.gd")

var type: int


# ============================================================
# Constructor
# ============================================================

func _init(obstacle_type: int) -> void:
	type = obstacle_type


# ============================================================
# Effect Methods
# ============================================================

## Returns the score multiplier penalty (1.0 = no penalty, 0.5 = 50% penalty)
func get_score_penalty() -> float:
	match type:
		ObstacleType.Type.CRACK:
			return 0.5  # 50% score penalty
		ObstacleType.Type.ICE:
			return 1.0  # No score penalty
		ObstacleType.Type.SPIKE:
			return 1.0  # No score penalty (game over instead)
		_:
			return 1.0


## Returns true if this obstacle breaks the combo chain
func breaks_combo() -> bool:
	match type:
		ObstacleType.Type.ICE:
			return true
		_:
			return false


## Returns true if this obstacle causes immediate game over
func causes_game_over() -> bool:
	match type:
		ObstacleType.Type.SPIKE:
			return true
		_:
			return false


# ============================================================
# Validation
# ============================================================

## Returns true if this obstacle has a valid type
func is_valid() -> bool:
	return type in [ObstacleType.Type.CRACK, ObstacleType.Type.ICE, ObstacleType.Type.SPIKE]


# ============================================================
# Display
# ============================================================

## Returns a human-readable name for this obstacle type
func get_display_name() -> String:
	match type:
		ObstacleType.Type.CRACK:
			return "Crack"
		ObstacleType.Type.ICE:
			return "Ice"
		ObstacleType.Type.SPIKE:
			return "Spike"
		_:
			return "Unknown"
