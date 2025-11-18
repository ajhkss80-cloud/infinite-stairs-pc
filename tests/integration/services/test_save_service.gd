## Test: SaveService
## Integration Test: 파일 시스템과 통합된 저장/로드 테스트

extends GutTest

var save_service: SaveService
var test_save_path: String = "user://test_high_scores.json"

func before_each():
	# Given: Create SaveService instance with test path
	save_service = SaveService.new(test_save_path)

	# Clean up test file if exists
	if FileAccess.file_exists(test_save_path):
		DirAccess.remove_absolute(test_save_path)


func after_each():
	# Clean up test file after each test
	if FileAccess.file_exists(test_save_path):
		DirAccess.remove_absolute(test_save_path)


# ==================== Save High Score Tests ====================

func test_save_high_score_creates_file():
	# Given: SaveService instance with no existing file
	# When: Save high score
	save_service.save_high_score(Difficulty.Level.EASY, 1000)

	# Then: File should be created
	assert_true(FileAccess.file_exists(test_save_path), "Save file should be created")


func test_save_high_score_stores_correct_value():
	# Given: SaveService instance
	# When: Save high score
	save_service.save_high_score(Difficulty.Level.NORMAL, 2500)

	# Then: Should be able to retrieve the same value
	var score = save_service.get_high_score(Difficulty.Level.NORMAL)
	assert_eq(score, 2500, "Should retrieve saved high score")


func test_save_multiple_difficulty_scores():
	# Given: SaveService instance
	# When: Save scores for different difficulties
	save_service.save_high_score(Difficulty.Level.EASY, 1000)
	save_service.save_high_score(Difficulty.Level.NORMAL, 2000)
	save_service.save_high_score(Difficulty.Level.HARD, 3000)

	# Then: Each difficulty should have its own score
	assert_eq(save_service.get_high_score(Difficulty.Level.EASY), 1000, "EASY score should be 1000")
	assert_eq(save_service.get_high_score(Difficulty.Level.NORMAL), 2000, "NORMAL score should be 2000")
	assert_eq(save_service.get_high_score(Difficulty.Level.HARD), 3000, "HARD score should be 3000")


# ==================== Get High Score Tests ====================

func test_get_high_score_returns_zero_when_no_file():
	# Given: SaveService instance with no save file
	# When: Get high score
	var score = save_service.get_high_score(Difficulty.Level.EASY)

	# Then: Should return 0
	assert_eq(score, 0, "Should return 0 when no save file exists")


func test_get_high_score_returns_zero_for_unsaved_difficulty():
	# Given: Save file with only EASY score
	save_service.save_high_score(Difficulty.Level.EASY, 1000)

	# When: Get score for NORMAL (not saved)
	var score = save_service.get_high_score(Difficulty.Level.NORMAL)

	# Then: Should return 0
	assert_eq(score, 0, "Should return 0 for unsaved difficulty")


# ==================== New High Score Check Tests ====================

func test_is_new_high_score_returns_true_when_higher():
	# Given: Existing high score of 1000
	save_service.save_high_score(Difficulty.Level.EASY, 1000)

	# When: Check if 1500 is new high score
	var is_new = save_service.is_new_high_score(Difficulty.Level.EASY, 1500)

	# Then: Should return true
	assert_true(is_new, "1500 should be new high score when existing is 1000")


func test_is_new_high_score_returns_false_when_lower():
	# Given: Existing high score of 1000
	save_service.save_high_score(Difficulty.Level.EASY, 1000)

	# When: Check if 500 is new high score
	var is_new = save_service.is_new_high_score(Difficulty.Level.EASY, 500)

	# Then: Should return false
	assert_false(is_new, "500 should not be new high score when existing is 1000")


func test_is_new_high_score_returns_true_when_equal():
	# Given: Existing high score of 1000
	save_service.save_high_score(Difficulty.Level.EASY, 1000)

	# When: Check if 1000 is new high score
	var is_new = save_service.is_new_high_score(Difficulty.Level.EASY, 1000)

	# Then: Should return true (equal is considered new)
	assert_true(is_new, "Equal score should be considered new high score")


func test_is_new_high_score_returns_true_when_no_previous_score():
	# Given: No previous high score
	# When: Check if any score is new high score
	var is_new = save_service.is_new_high_score(Difficulty.Level.EASY, 100)

	# Then: Should return true
	assert_true(is_new, "First score should always be new high score")


# ==================== Persistence Tests ====================

func test_scores_persist_across_instances():
	# Given: Save score with first instance
	save_service.save_high_score(Difficulty.Level.HARD, 5000)

	# When: Create new instance and load
	var new_service = SaveService.new(test_save_path)
	var score = new_service.get_high_score(Difficulty.Level.HARD)

	# Then: Score should persist
	assert_eq(score, 5000, "Score should persist across instances")


func test_update_high_score_only_if_higher():
	# Given: Existing score
	save_service.save_high_score(Difficulty.Level.NORMAL, 1000)

	# When: Try to save lower score
	save_service.save_high_score(Difficulty.Level.NORMAL, 500)

	# Then: Should keep higher score
	var score = save_service.get_high_score(Difficulty.Level.NORMAL)
	assert_eq(score, 1000, "Should keep higher score, not overwrite with lower")


# ==================== Error Handling Tests ====================

func test_handles_invalid_difficulty():
	# Given: SaveService instance
	# When: Try to get score for invalid difficulty
	var score = save_service.get_high_score(999)

	# Then: Should return 0 (safe default)
	assert_eq(score, 0, "Invalid difficulty should return 0")


func test_handles_negative_scores():
	# Given: SaveService instance
	# When: Try to save negative score
	save_service.save_high_score(Difficulty.Level.EASY, -100)

	# Then: Should not save negative score
	var score = save_service.get_high_score(Difficulty.Level.EASY)
	assert_eq(score, 0, "Should not save negative scores")
