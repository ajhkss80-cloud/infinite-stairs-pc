## SaveService
## 최고 점수를 저장하고 불러오는 서비스
## Application Layer - 파일 I/O 담당

class_name SaveService


# ==================== Constants ====================

const DEFAULT_SAVE_PATH = "user://high_scores.json"


# ==================== Properties ====================

var _save_path: String
var _high_scores: Dictionary = {}


# ==================== Constructor ====================

func _init(save_path: String = DEFAULT_SAVE_PATH) -> void:
	_save_path = save_path
	_load_scores()


# ==================== Public Methods ====================

## Save high score for specified difficulty
## Only saves if new score is higher than existing
func save_high_score(difficulty: int, score: float) -> void:
	# Error-first: Don't save negative scores
	if score < 0:
		return

	# Error-first: Don't save invalid difficulty
	if difficulty not in [Difficulty.Level.EASY, Difficulty.Level.NORMAL, Difficulty.Level.HARD]:
		return

	# Get current high score for this difficulty
	var current_high = get_high_score(difficulty)

	# Only save if new score is higher or equal
	if score >= current_high:
		_high_scores[str(difficulty)] = score
		_save_to_file()


## Get high score for specified difficulty
## Returns 0 if no score exists
func get_high_score(difficulty: int) -> float:
	var key = str(difficulty)
	if _high_scores.has(key):
		return _high_scores[key]
	return 0.0


## Check if score is a new high score for difficulty
func is_new_high_score(difficulty: int, score: float) -> bool:
	var current_high = get_high_score(difficulty)
	return score >= current_high


# ==================== Private Methods ====================

## Load scores from file
func _load_scores() -> void:
	if not FileAccess.file_exists(_save_path):
		_high_scores = {}
		return

	var file = FileAccess.open(_save_path, FileAccess.READ)
	if file == null:
		_high_scores = {}
		return

	var json_string = file.get_as_text()
	file.close()

	var json = JSON.new()
	var parse_result = json.parse(json_string)

	if parse_result == OK:
		var data = json.get_data()
		if data is Dictionary:
			_high_scores = data
		else:
			_high_scores = {}
	else:
		_high_scores = {}


## Save scores to file
func _save_to_file() -> void:
	var file = FileAccess.open(_save_path, FileAccess.WRITE)
	if file == null:
		push_error("Failed to open save file: " + _save_path)
		return

	var json_string = JSON.stringify(_high_scores, "\t")
	file.store_string(json_string)
	file.close()
