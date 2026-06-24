extends MiniGame
class_name PourTeaMiniGame

@onready var tea_progress_bar: TextureProgressBar = %TeaProgressBar
@onready var tea_surface: TextureRect = %TeaSurface
@onready var score_label: Label = %ScoreLabel
@onready var tutorial: Label = %Tutorial
@onready var animation_player: AnimationPlayer = $AnimationPlayer

static var show_tutorial: bool = true
var fill_speed:= 35.0
var tea_level: float = 0.0
var is_pouring: bool = false
var turbulence := 1.0
var bar_height := 300.0
var mat: ShaderMaterial

func _ready() -> void:
	super._ready()
	score_label.text = ""
	tutorial.hide()
	tea_progress_bar.value = 0
	mat = tea_surface.material
	animation_player.play("appear")
	
	if show_tutorial:
		tutorial.show()
	
func _input(event):
	if event.is_action_pressed("left_click"):
		if !is_pouring:
			$Pouring.play()
			is_pouring = true
			tutorial.hide()

	if event.is_action_released("left_click"):
		if is_pouring:
			$Pouring.stop()
			is_pouring = false
			_evaluate_result()

func _process(delta: float) -> void:
	if tea_progress_bar.value <= 80:
		if is_pouring:
			tea_level += fill_speed * delta
			tea_level = min(tea_level, tea_progress_bar.max_value)
			turbulence = move_toward(turbulence, 12.0, 1000.0 * delta)
		else:
			turbulence = move_toward(turbulence, 1.0, 10.0 * delta)

		tea_progress_bar.value = tea_level
		update_surface_position()
	else:
		_evaluate_result()
		
	if mat:
		mat.set_shader_parameter("wave_strength", max(turbulence, 5.0))
		mat.set_shader_parameter("wave_speed", max(turbulence,3.0))
		
func update_surface_position():
	var ratio := tea_level / tea_progress_bar.max_value
	var height := tea_progress_bar.size.y
	tea_surface.position.y = (tea_progress_bar.position.y + height - (ratio * height)) -200
	
func _evaluate_result():
	set_process_input(false)
	
	#await get_tree().create_timer(2.0).timeout
	
	if tea_level >= 67 and tea_level <= 72:
		animation_player.play("shake")
		final_score = 10
		score_label.text = "Perfect!"# + str(final_score)
		await get_tree().create_timer(0.2).timeout
		$Perfect.play()
	elif tea_level > 72:
		final_score = min(abs(10 - (tea_level - 80)), 1)
		score_label.text = "Overflow!"# + str(final_score)
		$Bad.play()
	else:
		final_score = max((10 - abs(tea_level - 76)), 1)
		score_label.text = "Too Little!"# + str(final_score)
		$Bad.play()
	
	await get_tree().create_timer(2.0).timeout

	finished.emit(final_score)
	show_tutorial = false
	animation_player.play("disappear")
