## GameOverView
## Game over screen - Thin UI, displays data only

extends Control

signal restart_requested(difficulty: int)
signal main_menu_requested

@onready var final_score_label = $CenterContainer/VBoxContainer/FinalScoreLabel
@onready var high_score_label = $CenterContainer/VBoxContainer/HighScoreLabel
@onready var new_high_score_label = $CenterContainer/VBoxContainer/NewHighScoreLabel

var _current_difficulty: int = Difficulty.Level.NORMAL


## Show game over screen with scores
## All logic is handled by caller (Thin UI principle)
func show_game_over(final_score: float, high_score: float, is_new_high: bool, difficulty: int):
	_current_difficulty = difficulty

	# Update labels
	final_score_label.text = "Score: %d" % int(final_score)
	high_score_label.text = "High Score: %d" % int(high_score)

	# Show new high score label if applicable
	new_high_score_label.visible = is_new_high

	# Make visible
	show()


func _on_restart_button_pressed():
	restart_requested.emit(_current_difficulty)
	hide()


func _on_main_menu_button_pressed():
	main_menu_requested.emit()
	hide()
