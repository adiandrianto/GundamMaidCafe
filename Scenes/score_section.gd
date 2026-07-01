extends Control
class_name  Scores

const LEVEL_SCENE = preload("uid://c2nvoc2kej8i5")

@onready var table_score: Label = %table_score
@onready var juice_score: Label = %juice_score
@onready var omelette_score: Label = %omelette_score
@onready var shaker_score: Label = %shaker_score
@onready var totalscores: Label = %Total_scores
@onready var continue_btn: TextureButton = %ContinueBtn
@onready var quit_btn: TextureButton = %QuitBtn

static var table_income = 10
static var juice = 10
static var shaker = 0
static var omelette = 0

var total_score = 0
var tween

func _ready() -> void:
	continue_btn.mouse_entered.connect(_play_hover_sound)
	continue_btn.disabled = true
	continue_btn.hide()
	quit_btn.mouse_entered.connect(_play_hover_sound)
	quit_btn.disabled = true
	quit_btn.hide()
	
	cumulative_scores()
	all_scorring()
	$DrumRoll.play()

func cumulative_scores():
	total_score =  table_income + juice + omelette
	print("Total score: ", total_score)

func count_table(value: int):
	table_score.text = str(value)

func count_juice(value: int):
	juice_score.text = str(value)

func count_shaker(value: int):
	shaker_score.text = str(value)
	
func count_omelette(value: int):
	omelette_score.text = str(value)

func count_total(value: int):
	totalscores.text = str(value)

func all_scorring():
	await animate_counter(count_table, table_income)
	shake_control(table_score)
	$AnimationPlayer.play("shake")
	await animate_counter(count_juice, juice)
	shake_control(juice_score)
	$AnimationPlayer.play("shake")
	await animate_counter(count_shaker, shaker)
	shake_control(shaker_score)
	$AnimationPlayer.play("shake")
	await animate_counter(count_omelette, omelette)
	shake_control(omelette_score)
	$AnimationPlayer.play("shake")
	await get_tree().create_timer(0.15).timeout
	await animate_counter(count_total, total_score)
	$AnimationPlayer.play("super_shake")
	shake_control(totalscores)
	$CoinFinal.play()
	
	quit_btn.disabled = false
	quit_btn.show()
	continue_btn.disabled = false
	continue_btn.show()
	print("Table score: ", table_income)
	print("Juice score: ", juice)
	print("Omelette score: ", omelette)
	print("Total score: ", total_score)

func animate_counter(method: Callable, target: int) -> void:
	await get_tree().create_timer(0.55).timeout

	var timer := Timer.new()
	timer.wait_time = 0.05
	timer.autostart = true
	add_child(timer)

	timer.timeout.connect(func():$Count.play())

	var tween := get_tree().create_tween()
	tween.tween_method(method, 0, target, 0.5)
	await tween.finished
	
	$Count.stop()
	timer.queue_free()
	
	if target != 0:
		$CoinDone.play()

func shake_control(label: Control):
	var original_pos := label.position
	var original_scale := label.scale

	var tween := get_tree().create_tween()
	tween.set_parallel()

	# Scale up then back down
	tween.tween_property(label, "scale", original_scale * 1.5, 0.08)
	tween.chain().tween_property(label, "scale", original_scale, 0.12)

	# Shake
	tween.tween_property(label, "position", original_pos + Vector2(-8, 0), 0.03)
	tween.chain().tween_property(label, "position", original_pos + Vector2(8, 0), 0.03)
	tween.chain().tween_property(label, "position", original_pos + Vector2(-4, 0), 0.03)
	tween.chain().tween_property(label, "position", original_pos, 0.03)
	
func _on_button_pressed() -> void:
	$Select.play()
	await $Select.finished
	if GameManager.current_level.level_param.level == 0:
		var level = LEVEL_SCENE.instantiate() as Level
		level.level_param = preload("uid://dd578tonen54x")
		get_tree().root.add_child(level)
		get_tree().current_scene.queue_free()
		get_tree().current_scene = level
	elif GameManager.current_level.level_param.level == 1:
		pass

func _on_button_2_pressed() -> void:
	$Select.play()
	await $Select.finished
	get_tree().quit()


func _play_hover_sound() -> void:
	$Hover.play()
