## StairValidator
## 플레이어 입력을 검증하는 클래스
## Pure GDScript - No Godot Node dependencies

class_name StairValidator


# ==================== Public Methods ====================

## Validate player input against stair direction
## Returns Dictionary with { "success": bool, "error": String }
func validate_input(input_direction: int, stair: Stair) -> Dictionary:
	# Error-first: Check for null stair
	if stair == null:
		return {
			"success": false,
			"error": "Stair is null"
		}

	# Error-first: Validate input direction
	if input_direction != Direction.Side.LEFT and input_direction != Direction.Side.RIGHT:
		return {
			"success": false,
			"error": "Invalid input direction"
		}

	# Check if input matches stair direction
	if input_direction == stair.direction:
		return {
			"success": true,
			"error": ""
		}
	else:
		return {
			"success": false,
			"error": "Wrong direction"
		}
