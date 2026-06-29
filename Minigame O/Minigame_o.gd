extends Node2D
class_name Omelette

@onready var objects: Node2D = $"../Objects"
@onready var minigame_o: Control = $".."
@onready var score: Node2D = $"."
@onready var score_1: Node2D = $Score1
@onready var score_2: Node2D = $Score2
@onready var score_3: Node2D = $Score3
@onready var tomat: Node2D = $"../Objects/Tomat"
@onready var sosis: Node2D = $"../Objects/Sosis"
@onready var sosis_2: Node2D = $"../Objects/Sosis2"
@onready var label: Label = $"../Label"

var tween
var score1
var score2
var score3
var total_score
var total_score_text : String

func _ready() -> void:
	score1 = get_node("Score1")
	print(score1)
	score2 = get_node("Score2")
	print(score2)
	score3 = get_node("Score3")
	print(score3)

func _process(delta):
	if score1.score == 10 and score2.score == 20 and score3.score == 20:
		tween = get_tree().create_tween()
		tween.tween_property(label, "text", "Great!", 0).set_delay(1.25)
		await get_tree().create_timer(2).timeout
		total_score = 10
		get_score()
		get_tree().change_scene_to_file("res://Scenes/score_section.tscn")
	score_z_index_reset()

func get_score():
	print("Score1 = ", score1.score)
	print("Score2 = ", score2.score)
	print("Score3 = ", score3.score)
	
	Scores.omelette = Scores.omelette + total_score
	print("Current omelette score: ", Scores.omelette)


func score_z_index_reset():
	score_1.z_index = 0
	score_2.z_index = 0
	score_3.z_index = 0

func object_z_index_reset():
	tomat.z_index = 0
	sosis.z_index = 0
	sosis_2.z_index = 0
