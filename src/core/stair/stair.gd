## Stair
## 계단 데이터 모델
## Pure data class (no logic)

class_name Stair

# ==================== Properties ====================

## Direction of the stair (LEFT or RIGHT)
var direction: int

## Index/position of the stair in the sequence
var index: int

## Obstacle on this stair (null if no obstacle)
var obstacle = null


# ==================== Constructor ====================

func _init(stair_direction: int = Direction.Side.LEFT, stair_index: int = 0, stair_obstacle = null) -> void:
	direction = stair_direction
	index = stair_index
	obstacle = stair_obstacle


# ==================== Helper Methods ====================

## Returns true if this stair has an obstacle
func has_obstacle() -> bool:
	return obstacle != null
