## GameView
## Main game scene - handles rendering and input

extends Node2D

signal game_over(final_score: float, high_score: float, is_new_high: bool)

var game_controller: GameController
var current_difficulty: int

@onready var score_label = $HUD/ScoreLabel
@onready var timer_bar = $HUD/TimerBar
@onready var stair_container = $StairContainer
@onready var debug_label = $HUD/DebugLabel

# Visual settings
const STAIR_WIDTH = 100
const STAIR_HEIGHT = 40
const STAIR_SPACING = 60
const MAX_VISIBLE_STAIRS = 10


func _ready():
	game_controller = GameController.new()
	set_process(false)  # Don't process until game starts


func start_game(difficulty: int):
	current_difficulty = difficulty
	game_controller.start_game(difficulty)
	set_process(true)
	_render_stairs()
	_update_ui()


func _process(delta):
	if game_controller.is_game_over():
		_handle_game_over()
		return

	# Update game controller
	game_controller.update(delta)

	# Update UI
	_update_ui()


func _input(event):
	if game_controller.is_game_over():
		return

	if event.is_action_pressed("move_left"):
		_process_player_input(Direction.Side.LEFT)
	elif event.is_action_pressed("move_right"):
		_process_player_input(Direction.Side.RIGHT)


func _process_player_input(direction: int):
	game_controller.process_input(direction)

	if game_controller.is_game_over():
		_handle_game_over()
	else:
		_render_stairs()
		_update_ui()


func _update_ui():
	# Update score
	score_label.text = "Score: %d" % int(game_controller.get_current_score())

	# Update timer bar
	var difficulty_config = DifficultyConfig.new()
	var timeout = difficulty_config.get_input_timeout(current_difficulty)
	var elapsed = game_controller.get_elapsed_time()
	timer_bar.value = 1.0 - (elapsed / timeout)

	# Change color based on time remaining
	if timer_bar.value < 0.3:
		timer_bar.modulate = Color(1, 0, 0)  # Red
	elif timer_bar.value < 0.6:
		timer_bar.modulate = Color(1, 1, 0)  # Yellow
	else:
		timer_bar.modulate = Color(0, 1, 0)  # Green

	# Update debug info
	var stair = game_controller.get_current_stair()
	if stair:
		var dir_text = "LEFT" if stair.direction == Direction.Side.LEFT else "RIGHT"
		debug_label.text = "Current Stair: %s (Press %s)" % [dir_text, "A/←" if stair.direction == Direction.Side.LEFT else "D/→"]


func _render_stairs():
	# Clear existing stairs
	for child in stair_container.get_children():
		child.queue_free()

	# Render current stair
	var stair = game_controller.get_current_stair()
	if stair:
		_create_stair_visual(stair, 0)


func _create_stair_visual(stair: Stair, visual_index: int):
	var stair_node = ColorRect.new()
	stair_node.custom_minimum_size = Vector2(STAIR_WIDTH, STAIR_HEIGHT)
	stair_node.size = Vector2(STAIR_WIDTH, STAIR_HEIGHT)

	# Position based on direction
	var x_pos = 540 if stair.direction == Direction.Side.LEFT else 740
	var y_pos = 400 - (visual_index * STAIR_SPACING)

	stair_node.position = Vector2(x_pos, y_pos)

	# Color based on direction
	if stair.direction == Direction.Side.LEFT:
		stair_node.color = Color(0.2, 0.8, 0.2)  # Green
	else:
		stair_node.color = Color(0.2, 0.2, 0.8)  # Blue

	stair_container.add_child(stair_node)


func _handle_game_over():
	set_process(false)
	var final_score = game_controller.get_current_score()
	var high_score = game_controller.get_high_score()
	var is_new_high = game_controller.save_if_high_score()
	await get_tree().create_timer(1.0).timeout
	game_over.emit(final_score, high_score, is_new_high)
