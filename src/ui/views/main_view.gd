## MainView
## Main menu and game flow coordinator

extends Node

@onready var main_menu = $MainMenu
@onready var game_over_scene = $GameOver

var game_scene_packed = preload("res://scenes/game/game_scene.tscn")
var current_game_scene: Node = null
var current_difficulty: int = Difficulty.Level.NORMAL


func _ready():
	main_menu.show()
	game_over_scene.hide()

	# Connect game over signals
	game_over_scene.restart_requested.connect(_on_restart_requested)
	game_over_scene.main_menu_requested.connect(_on_main_menu_requested)


func _on_easy_button_pressed():
	_start_game(Difficulty.Level.EASY)


func _on_normal_button_pressed():
	_start_game(Difficulty.Level.NORMAL)


func _on_hard_button_pressed():
	_start_game(Difficulty.Level.HARD)


func _on_quit_button_pressed():
	get_tree().quit()


func _start_game(difficulty: int):
	current_difficulty = difficulty
	main_menu.hide()
	game_over_scene.hide()

	# Create game scene
	current_game_scene = game_scene_packed.instantiate()
	add_child(current_game_scene)
	current_game_scene.start_game(difficulty)

	# Connect game over signal
	current_game_scene.game_over.connect(_on_game_over)


func _on_game_over(final_score: float, high_score: float, is_new_high: bool):
	# Remove game scene
	if current_game_scene:
		current_game_scene.queue_free()
		current_game_scene = null

	# Show game over screen with scores
	game_over_scene.show_game_over(final_score, high_score, is_new_high, current_difficulty)


func _on_restart_requested(difficulty: int):
	_start_game(difficulty)


func _on_main_menu_requested():
	game_over_scene.hide()
	main_menu.show()
