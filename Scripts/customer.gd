extends Area2D
class_name Customer

@onready var sprite: Sprite2D = %Sprite

var table_entered: Table = null
var dragging := false
var can_drag := true
var queue: Node2D

func _ready() -> void:
	if sprite.material:
		sprite.material = sprite.material.duplicate()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:

			var clicked = get_area_under_mouse()

			if clicked == self:
				dragging = true

		elif event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
			dragging = false

func get_area_under_mouse() -> Area2D:
	var space = get_world_2d().direct_space_state

	var query := PhysicsPointQueryParameters2D.new()
	query.position = get_global_mouse_position()
	query.collide_with_areas = true

	var results = space.intersect_point(query)

	if results.is_empty():
		return null

	return results[0].collider
	
#func _input_event(viewport, event, shape_idx):
	#print("clicked")
	#if event is InputEventMouseButton:
		#if event.button_index == MOUSE_BUTTON_LEFT and can_drag:
			#dragging = event.pressed
				
func _process(_delta):
	if dragging:
		print("dragging")
		global_position = get_global_mouse_position()
		give_outline()
	else:
		remove_outline()
		if table_entered == null:
			if queue:
				queue.update_layout()
		else:
			table_entered.assign_customer(self)

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
	table_entered = area.get_parent()

func _on_area_exited(area: Area2D) -> void:
	if area.get_parent() is Table:
		table_entered = null
