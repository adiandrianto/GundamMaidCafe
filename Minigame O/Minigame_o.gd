extends Node2D

@onready var objects: Node2D = $"../Objects"
@onready var display_score: MarginContainer = $"../Display_score"
@onready var minigame_o: Control = $".."
@onready var label_2: Label = $"../Display_score/MarginContainer/HBoxContainer/Label2"
@onready var score: Node2D = $"."
@onready var score_1: Node2D = $Score1
@onready var score_2: Node2D = $Score2
@onready var score_3: Node2D = $Score3
@onready var tomat: Node2D = $"../Objects/Tomat"
@onready var sosis: Node2D = $"../Objects/Sosis"
@onready var sosis_2: Node2D = $"../Objects/Sosis2"

var score1
var score2
var score3
static var total_score
var total_score_text : String

func _ready() -> void:
	display_score.visible = false
	score1 = get_node("Score1")
	print(score1)
	score2 = get_node("Score2")
	print(score2)
	score3 = get_node("Score3")
	print(score3)

func _process(delta):
	score_z_index_reset()

func get_score():
	if score1.score >= 100:
		score1.score = 100
	if score2.score >= 100:
		score2.score = 100
	if score3.score >= 100:
		score3.score = 100
	print("Score1 = ", score1.score)
	print("Score2 = ", score2.score)
	print("Score3 = ", score3.score)
	total_score = (score1.score + score2.score + score3.score)/3
	
	Scores.omelette = Scores.omelette + total_score
	print("Current omelette score: ", Scores.omelette)
	
	print("Total score = ", total_score)
	label_2.text = str(total_score)
	

func _on_button_pressed() -> void:
	objects.z_index = 0
	minigame_o.z_index = 0
	score.z_index = 0
	object_z_index_reset()
	display_score.z_index = 1
	get_score()
	display_score.visible = true

func score_z_index_reset():
	score_1.z_index = 0
	score_2.z_index = 0
	score_3.z_index = 0

func object_z_index_reset():
	tomat.z_index = 0
	sosis.z_index = 0
	sosis_2.z_index = 0

func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/score_section.tscn")
