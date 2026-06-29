extends Node2D

var score : int


func _ready() -> void:
	score = 0

func _process(delta: float) -> void:
	pass

func area_entered():
	score += 10
	print("Current Score3 is ", score)

func area_exit():
	score -= 10
	print("Current Score3 is ", score)


func _on_area_2d_10_area_entered(area: Area2D) -> void:
	area_entered()

func _on_area_2d_10_area_exited(area: Area2D) -> void:
	area_exit()
