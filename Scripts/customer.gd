extends Area2D
class_name Customer

@onready var sprite: Sprite2D = $Sprite

var is_on_table_area: bool = false
var dragging := false
var initial_position: Vector2

func _ready() -> void:
	initial_position = global_position
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed

func _process(_delta):
	if dragging:
		global_position = get_global_mouse_position()
		give_outline()
	else:
		remove_outline()
		if not is_on_table_area:
			global_position = initial_position
		else:
			pass # taruh meja

func give_outline():
	if not sprite:
		return
	var mat := sprite.material as ShaderMaterial
	if mat:
		mat.set_shader_parameter("width", 2)

func remove_outline():
	if not sprite:
		return

	var mat := sprite.material as ShaderMaterial
	if mat:
		mat.set_shader_parameter("width", 0)
	
func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is not Table:
		return
	is_on_table_area = true
