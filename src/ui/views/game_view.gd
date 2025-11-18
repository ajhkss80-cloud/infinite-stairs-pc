## GameView
## Main game scene - handles rendering and input

extends Node2D

signal game_over(final_score: float, high_score: float, is_new_high: bool)

var game_controller: GameController
var current_difficulty: int

@onready var score_label = $HUD/ScoreLabel
@onready var stairs_label = $HUD/StairsLabel
@onready var combo_label = $HUD/ComboLabel
@onready var difficulty_label = $HUD/DifficultyLabel
@onready var timer_bar = $HUD/TimerBar
@onready var stair_container = $StairContainer
@onready var debug_label = $HUD/DebugLabel
@onready var star_container = $Background/StarContainer

# Visual settings
const STAIR_WIDTH = 100
const STAIR_HEIGHT = 40
const STAIR_SPACING = 60
const MAX_VISIBLE_STAIRS = 10


func _ready():
	game_controller = GameController.new()
	set_process(false)  # Don't process until game starts
	_create_background_stars()


func start_game(difficulty: int):
	current_difficulty = difficulty
	game_controller.start_game(difficulty)
	set_process(true)
	_update_difficulty_label()
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
	const ObstacleType = preload("res://src/core/obstacle/obstacle_type.gd")

	var prev_score = game_controller.get_current_score()
	var prev_combo = game_controller.get_consecutive_success()

	# Check for obstacle before processing (for visual feedback)
	var current_stair = game_controller.get_current_stair()
	var had_obstacle = current_stair.has_obstacle()
	var obstacle_type = current_stair.obstacle.type if had_obstacle else -1

	game_controller.process_input(direction)

	if game_controller.is_game_over():
		# Show obstacle message if game over was caused by SPIKE
		if had_obstacle and obstacle_type == ObstacleType.Type.SPIKE:
			_show_floating_text("SPIKE!", Color(1, 0, 0), 1.5)
		_handle_game_over()
	else:
		# Calculate score gained for floating text
		var new_score = game_controller.get_current_score()
		var score_gain = new_score - prev_score
		var new_combo = game_controller.get_consecutive_success()

		# Show obstacle feedback
		if had_obstacle:
			match obstacle_type:
				ObstacleType.Type.CRACK:
					_show_floating_text("CRACK! -50%", Color(1, 1, 0))
				ObstacleType.Type.ICE:
					_show_floating_text("ICE! Combo Lost", Color(0, 1, 1))

		# Show floating text feedback
		if score_gain > 0:
			_show_floating_text("+%d" % int(score_gain), Color(0, 1, 0))

		# Show combo milestone
		if new_combo >= 10 and new_combo % 10 == 0:
			_show_floating_text("COMBO x%d!" % (new_combo / 10), Color(1, 0.8, 0), 1.5)

		_render_stairs()
		_update_ui()


func _update_ui():
	# Update score
	score_label.text = "Score: %d" % int(game_controller.get_current_score())

	# Update stairs count
	stairs_label.text = "Stairs: %d" % game_controller.get_stairs_climbed()

	# Update combo with visual emphasis
	var combo = game_controller.get_consecutive_success()
	combo_label.text = "Combo: %d" % combo
	if combo >= 10:
		combo_label.modulate = Color(1, 0.8, 0)  # Gold for combo
	else:
		combo_label.modulate = Color(1, 1, 1)  # White

	# Update timer bar
	var difficulty_config = DifficultyConfig.new()
	var timeout = difficulty_config.get_input_timeout(current_difficulty)
	var elapsed = game_controller.get_elapsed_time()
	timer_bar.value = 1.0 - (elapsed / timeout)

	# Enhanced color gradation based on time remaining
	if timer_bar.value < 0.2:
		timer_bar.modulate = Color(1, 0, 0)  # Bright red (critical)
	elif timer_bar.value < 0.4:
		timer_bar.modulate = Color(1, 0.3, 0)  # Orange-red
	elif timer_bar.value < 0.6:
		timer_bar.modulate = Color(1, 0.7, 0)  # Orange
	elif timer_bar.value < 0.8:
		timer_bar.modulate = Color(1, 1, 0)  # Yellow
	else:
		timer_bar.modulate = Color(0, 1, 0)  # Green (safe)

	# Update debug info
	var stair = game_controller.get_current_stair()
	if stair:
		var dir_text = "LEFT" if stair.direction == Direction.Side.LEFT else "RIGHT"
		debug_label.text = "Current Stair: %s (Press %s)" % [dir_text, "A/←" if stair.direction == Direction.Side.LEFT else "D/→"]


func _update_difficulty_label():
	match current_difficulty:
		Difficulty.Level.EASY:
			difficulty_label.text = "EASY"
			difficulty_label.modulate = Color(0, 1, 0)  # Green
		Difficulty.Level.NORMAL:
			difficulty_label.text = "NORMAL"
			difficulty_label.modulate = Color(1, 1, 0)  # Yellow
		Difficulty.Level.HARD:
			difficulty_label.text = "HARD"
			difficulty_label.modulate = Color(1, 0, 0)  # Red


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

	# Add obstacle visual if present
	if stair.has_obstacle():
		_add_obstacle_visual(stair_node, stair.obstacle)

	# Spawn animation: scale from 0 to 1 with bounce
	stair_node.scale = Vector2(0, 0)
	var tween = create_tween()
	tween.tween_property(stair_node, "scale", Vector2(1, 1), 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


func _add_obstacle_visual(parent: ColorRect, obstacle):
	const ObstacleType = preload("res://src/core/obstacle/obstacle_type.gd")

	# Create obstacle indicator
	var obstacle_icon = ColorRect.new()
	obstacle_icon.custom_minimum_size = Vector2(20, 20)
	obstacle_icon.size = Vector2(20, 20)
	obstacle_icon.position = Vector2(40, 10)  # Center of stair

	# Color and pattern based on obstacle type
	match obstacle.type:
		ObstacleType.Type.CRACK:
			# Yellow warning pattern (score penalty)
			obstacle_icon.color = Color(1, 1, 0, 0.8)
		ObstacleType.Type.ICE:
			# Cyan ice pattern (combo break)
			obstacle_icon.color = Color(0, 1, 1, 0.8)
		ObstacleType.Type.SPIKE:
			# Red danger pattern (game over)
			obstacle_icon.color = Color(1, 0, 0, 0.9)

	parent.add_child(obstacle_icon)

	# Add pulsing animation for visibility
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property(obstacle_icon, "modulate:a", 0.5, 0.5)
	tween.tween_property(obstacle_icon, "modulate:a", 1.0, 0.5)


func _handle_game_over():
	set_process(false)
	var final_score = game_controller.get_current_score()
	var high_score = game_controller.get_high_score()
	var is_new_high = game_controller.save_if_high_score()
	await get_tree().create_timer(1.0).timeout
	game_over.emit(final_score, high_score, is_new_high)


func _show_floating_text(text: String, color: Color, scale_mult: float = 1.0):
	# Create floating label
	var label = Label.new()
	label.text = text
	label.modulate = color
	label.z_index = 100

	# Position at center-top of screen
	label.position = Vector2(640 - 50, 300)
	label.scale = Vector2(scale_mult, scale_mult)

	# Add custom theme for better visibility
	var font_size = 32 if scale_mult > 1.0 else 24
	label.add_theme_font_size_override("font_size", font_size)

	add_child(label)

	# Animate: float up and fade out
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(label, "position:y", label.position.y - 100, 1.0)
	tween.tween_property(label, "modulate:a", 0.0, 1.0)
	tween.set_parallel(false)

	# Clean up after animation
	tween.tween_callback(label.queue_free)


func _create_background_stars():
	# Create animated star field for visual ambiance
	for i in range(50):
		var star = ColorRect.new()
		star.custom_minimum_size = Vector2(2, 2)
		star.size = Vector2(2, 2)
		star.position = Vector2(randf() * 1280, randf() * 720)
		star.color = Color(1, 1, 1, randf_range(0.3, 0.8))

		star_container.add_child(star)

		# Animate star falling slowly
		var tween = create_tween()
		tween.set_loops()
		var duration = randf_range(3.0, 6.0)
		tween.tween_property(star, "position:y", star.position.y + 720, duration)
		tween.tween_callback(func(): star.position.y = -10)
