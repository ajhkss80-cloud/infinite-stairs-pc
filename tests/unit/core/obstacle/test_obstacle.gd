## Unit Tests for Obstacle
## Tests obstacle data model and properties

extends GutTest

const Obstacle = preload("res://src/core/obstacle/obstacle.gd")
const ObstacleType = preload("res://src/core/obstacle/obstacle_type.gd")


# ============================================================
# Constructor Tests
# ============================================================

func test_obstacle_initializes_with_type():
	var obstacle = Obstacle.new(ObstacleType.Type.CRACK)
	assert_eq(obstacle.type, ObstacleType.Type.CRACK, "Obstacle should initialize with CRACK type")


func test_obstacle_initializes_with_ice_type():
	var obstacle = Obstacle.new(ObstacleType.Type.ICE)
	assert_eq(obstacle.type, ObstacleType.Type.ICE, "Obstacle should initialize with ICE type")


func test_obstacle_initializes_with_spike_type():
	var obstacle = Obstacle.new(ObstacleType.Type.SPIKE)
	assert_eq(obstacle.type, ObstacleType.Type.SPIKE, "Obstacle should initialize with SPIKE type")


# ============================================================
# Effect Tests
# ============================================================

func test_crack_obstacle_has_score_penalty():
	var obstacle = Obstacle.new(ObstacleType.Type.CRACK)
	assert_eq(obstacle.get_score_penalty(), 0.5, "CRACK should have 50% score penalty")


func test_ice_obstacle_breaks_combo():
	var obstacle = Obstacle.new(ObstacleType.Type.ICE)
	assert_true(obstacle.breaks_combo(), "ICE should break combo")


func test_spike_obstacle_causes_game_over():
	var obstacle = Obstacle.new(ObstacleType.Type.SPIKE)
	assert_true(obstacle.causes_game_over(), "SPIKE should cause game over")


func test_crack_does_not_break_combo():
	var obstacle = Obstacle.new(ObstacleType.Type.CRACK)
	assert_false(obstacle.breaks_combo(), "CRACK should not break combo")


func test_crack_does_not_cause_game_over():
	var obstacle = Obstacle.new(ObstacleType.Type.CRACK)
	assert_false(obstacle.causes_game_over(), "CRACK should not cause game over")


func test_ice_does_not_cause_game_over():
	var obstacle = Obstacle.new(ObstacleType.Type.ICE)
	assert_false(obstacle.causes_game_over(), "ICE should not cause game over")


func test_ice_has_no_score_penalty():
	var obstacle = Obstacle.new(ObstacleType.Type.ICE)
	assert_eq(obstacle.get_score_penalty(), 1.0, "ICE should have no score penalty")


func test_spike_has_no_score_penalty():
	var obstacle = Obstacle.new(ObstacleType.Type.SPIKE)
	assert_eq(obstacle.get_score_penalty(), 1.0, "SPIKE should have no score penalty (game over instead)")


# ============================================================
# Validation Tests
# ============================================================

func test_obstacle_type_is_valid():
	var obstacle = Obstacle.new(ObstacleType.Type.CRACK)
	assert_true(obstacle.is_valid(), "Obstacle with valid type should be valid")


func test_obstacle_with_invalid_type_is_invalid():
	var obstacle = Obstacle.new(999)  # Invalid type
	assert_false(obstacle.is_valid(), "Obstacle with invalid type should be invalid")


# ============================================================
# Property Tests
# ============================================================

func test_obstacle_has_display_name_crack():
	var obstacle = Obstacle.new(ObstacleType.Type.CRACK)
	assert_eq(obstacle.get_display_name(), "Crack", "CRACK should have display name 'Crack'")


func test_obstacle_has_display_name_ice():
	var obstacle = Obstacle.new(ObstacleType.Type.ICE)
	assert_eq(obstacle.get_display_name(), "Ice", "ICE should have display name 'Ice'")


func test_obstacle_has_display_name_spike():
	var obstacle = Obstacle.new(ObstacleType.Type.SPIKE)
	assert_eq(obstacle.get_display_name(), "Spike", "SPIKE should have display name 'Spike'")


func test_obstacle_invalid_type_has_unknown_display_name():
	var obstacle = Obstacle.new(999)
	assert_eq(obstacle.get_display_name(), "Unknown", "Invalid type should have display name 'Unknown'")
