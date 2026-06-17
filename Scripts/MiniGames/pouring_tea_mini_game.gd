extends Control

@onready var tea_progress_bar: TextureProgressBar = %TeaProgressBar
@onready var tea_surface: TextureRect = %TeaSurface
#@onready var glass: TextureRect = %Glass

var fill_speed:= 40.0
var tea_level: float = 0.0
var is_pouring: bool = false
var turbulence := 1.0
var bar_height := 300.0
var mat: ShaderMaterial

func _ready() -> void:
	tea_progress_bar.value = 0
	mat = tea_surface.material
	
func _input(event):
	if event.is_action_pressed("left_click"):
		if !is_pouring:
			$Pouring.play()
			is_pouring = true

	if event.is_action_released("left_click"):
		if is_pouring:
			$Pouring.stop()
			is_pouring = false
			_evaluate_result()

func _process(delta: float) -> void:
	if is_pouring:
		tea_level += fill_speed * delta
		tea_level = min(tea_level, tea_progress_bar.max_value)

		turbulence = move_toward(turbulence, 6.0, 15.0 * delta)
	else:
		turbulence = move_toward(
			turbulence,
			1.0,
			10.0 * delta
		)

	tea_progress_bar.value = tea_level
	update_surface_position()
	if mat:
		mat.set_shader_parameter( "amplitude", turbulence )
		
func update_surface_position():
	var ratio := tea_level / tea_progress_bar.max_value
	var height := tea_progress_bar.size.y
	tea_surface.position.y = tea_progress_bar.position.y + height - (ratio * height)
	
func _evaluate_result():
	if tea_level >= 75 and tea_level <= 85:
		print("Perfect!")
	elif tea_level > 85:
		print("Overflow!")
	else:
		print("Too Little!")
