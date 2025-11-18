## MainView
## Main menu and game flow coordinator

extends Node

@onready var main_menu = $MainMenu
var game_scene_packed = preload("res://scenes/game/game_scene.tscn")
var current_game_scene: Node = null


func _ready():
	main_menu.show()


func _on_easy_button_pressed():
	_start_game(Difficulty.Level.EASY)


func _on_normal_button_pressed():
	_start_game(Difficulty.Level.NORMAL)


func _on_hard_button_pressed():
	_start_game(Difficulty.Level.HARD)


func _on_quit_button_pressed():
	get_tree().quit()


func _start_game(difficulty: int):
	main_menu.hide()

	# Create game scene
	current_game_scene = game_scene_packed.instantiate()
	add_child(current_game_scene)
	current_game_scene.start_game(difficulty)

	# Connect game over signal
	current_game_scene.game_over.connect(_on_game_over)


func _on_game_over(final_score: float):
	# Remove game scene
	if current_game_scene:
		current_game_scene.queue_free()
		current_game_scene = null

	# Show main menu
	main_menu.show()

	# TODO: Show game over screen with score
	print("Game Over! Score: ", final_score)
