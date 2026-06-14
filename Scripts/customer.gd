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
				begin_drag()

		elif event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
			end_drag()

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
		global_position = get_global_mouse_position()

func begin_drag():
	dragging = true
	give_outline()
	queue.update_layout()

	reparent(get_tree().current_scene, true)

func end_drag():
	dragging = false
	remove_outline()
	if table_entered:
		table_entered.assign_customer(self)
	else:
		return_to_queue()

func return_to_queue():
	if get_parent() != queue:
		reparent(queue, true)

	queue.update_layout()
	
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
