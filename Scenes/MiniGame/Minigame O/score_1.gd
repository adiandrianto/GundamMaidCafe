extends Node2D

@onready var area_2d: Area2D = $Area2D
@onready var area_2d_2: Area2D = $Area2D2
@onready var area_2d_3: Area2D = $Area2D3
@onready var area_2d_4: Area2D = $Area2D4
@onready var area_2d_5: Area2D = $Area2D5
@onready var area_2d_6: Area2D = $Area2D6
@onready var area_2d_7: Area2D = $Area2D7
@onready var area_2d_8: Area2D = $Area2D8
@onready var area_2d_9: Area2D = $Area2D9
@onready var area_2d_10: Area2D = $Area2D10
var score : int


func _ready() -> void:
	score = 0

func _process(delta: float) -> void:
	pass

func area_entered():
	score += 10
	print("Current Score1 is ", score)

func area_exit():
	score -= 10
	print("Current Score1 is ", score)

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
