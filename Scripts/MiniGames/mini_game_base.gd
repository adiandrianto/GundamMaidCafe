extends Node
class_name MiniGame

signal finished(score: int)

var final_score
var mini_game_name

func _ready() -> void:
	get_tree().paused = true

func _exit_tree() -> void:
	GameManager.current_level.add_income(final_score)
	get_tree().paused = false
