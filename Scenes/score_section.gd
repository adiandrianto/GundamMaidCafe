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
var tween


func _ready() -> void:
	cumulative_scores()
	all_scorring()
	
	print(total_score)

func cumulative_scores():
	total_score =  table + juice + omelette
	print("Total score: ", total_score)

func count_table(value: int):
	table_score.text = str(value)

func count_juice(value: int):
	juice_score.text = str(value)

func count_omelette(value: int):
	omelette_score.text = str(value)

func count_total(value: int):
	totalscores.text = str(value)

func all_scorring():
	tween = get_tree().create_tween()
	tween.tween_method(count_table, 0, table, 0.7).set_delay(1)
	tween.tween_method(count_juice, 0, juice, 0.7).set_delay(1)
	tween.tween_method(count_omelette, 0, omelette, 0.7).set_delay(1)
	tween.tween_method(count_total, 0, total_score, 0.7).set_delay(1)
	print("Table score: ", table)
	print("Juice score: ", juice)
	print("Omelette score: ", omelette)
	print("Total score: ", total_score)


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Minigame O/minigame_o.tscn")


func _on_button_2_pressed() -> void:
	get_tree().quit()
