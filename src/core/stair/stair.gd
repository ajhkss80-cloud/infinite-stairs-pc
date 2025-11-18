## Stair
## 계단 데이터 모델
## Pure data class (no logic)

class_name Stair

# ==================== Properties ====================

## Direction of the stair (LEFT or RIGHT)
var direction: int

## Index/position of the stair in the sequence
var index: int

## Whether this stair has an obstacle
var has_obstacle: bool = false


# ==================== Constructor ====================

func _init(stair_direction: int = Direction.Side.LEFT, stair_index: int = 0) -> void:
	direction = stair_direction
	index = stair_index
