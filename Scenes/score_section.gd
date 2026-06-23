extends Control
class_name  Scores

@onready var table_score: Label = $MarginContainer/VBoxContainer/Score_display/MarginContainer/VBoxContainer/Table/table_score
@onready var juice_score: Label = $MarginContainer/VBoxContainer/Score_display/MarginContainer/VBoxContainer/Juice/juice_score
@onready var omelette_score: Label = $MarginContainer/VBoxContainer/Score_display/MarginContainer/VBoxContainer/Omelette/omelette_score
@onready var totalscores: Label = $MarginContainer/VBoxContainer/Score_display/MarginContainer/VBoxContainer/Total_score/Total_scores

static var table = 0
static var juice = 0
static var omelette = 0
var total_score = 0


func _ready() -> void:
	cumulative_scores()
	all_scorring()
	print(total_score)

func cumulative_scores():
	total_score =  table + juice + omelette
	print("Total score: ", total_score)

func all_scorring():
	table_score.text = str(table)
	juice_score.text = str(juice)
	omelette_score.text = str(omelette)
	totalscores.text = str(total_score)
	print("Table score: ", table)
	print("Juice score: ", juice)
	print("Omelette score: ", omelette)


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Minigame O/minigame_o.tscn")


func _on_button_2_pressed() -> void:
	get_tree().quit()
