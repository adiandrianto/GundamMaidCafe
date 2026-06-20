extends Node

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

func _on_area_2d_area_entered(area: Area2D) -> void:
	area_entered()

func _on_area_2d_area_exited(area: Area2D) -> void:
	area_exit()


func _on_area_2d_2_area_entered(area: Area2D) -> void:
	area_entered()

func _on_area_2d_2_area_exited(area: Area2D) -> void:
	area_exit()

func _on_area_2d_3_area_entered(area: Area2D) -> void:
	area_entered()

func _on_area_2d_3_area_exited(area: Area2D) -> void:
	area_exit()


func _on_area_2d_4_area_entered(area: Area2D) -> void:
	area_entered()

func _on_area_2d_4_area_exited(area: Area2D) -> void:
	area_exit()


func _on_area_2d_5_area_entered(area: Area2D) -> void:
	area_entered()

func _on_area_2d_5_area_exited(area: Area2D) -> void:
	area_exit()


func _on_area_2d_6_area_entered(area: Area2D) -> void:
	area_entered()

func _on_area_2d_6_area_exited(area: Area2D) -> void:
	area_exit()


func _on_area_2d_7_area_entered(area: Area2D) -> void:
	area_entered()

func _on_area_2d_7_area_exited(area: Area2D) -> void:
	area_exit()


func _on_area_2d_8_area_entered(area: Area2D) -> void:
	area_entered()

func _on_area_2d_8_area_exited(area: Area2D) -> void:
	area_exit()


func _on_area_2d_9_area_entered(area: Area2D) -> void:
	area_entered()

func _on_area_2d_9_area_exited(area: Area2D) -> void:
	area_exit()


func _on_area_2d_10_area_entered(area: Area2D) -> void:
	area_entered()

func _on_area_2d_10_area_exited(area: Area2D) -> void:
	area_exit()
