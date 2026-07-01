extends Node2D

signal all_object_moved

@onready var object_detection: Area2D = %ObjectDetection

const COLLISION_MASK_OBJECT = 1

var screen_size
var object_being_dragged

func _ready() -> void:
	screen_size = get_viewport_rect()

func _physics_process(delta) -> void:
	if object_being_dragged:
		var mouse_pos = get_global_mouse_position() + Vector2(-960, -540)
		object_being_dragged.position = mouse_pos

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var object = raycast_check_for_object()
			if object:
				object.z_index += 1
				object_being_dragged = object
		else:
			object_being_dragged = null
			await get_tree().physics_frame
			if are_all_objects_outside():
				all_object_moved.emit()

func raycast_check_for_object():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_OBJECT
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		print(result[0].collider.get_parent())
		return result[0].collider.get_parent()
	return null

func are_all_objects_outside() -> bool:
	for obj in self.get_children():
		if is_object_inside_area(obj):
			print("false")
			return false
		
	print("true")
	return true
	
func is_object_inside_area(obj: Node2D) -> bool:
	var shape := object_detection.get_node("CollisionShape2D").shape as RectangleShape2D

	var local_pos = object_detection.to_local(obj.global_position)
	var rect = Rect2(-shape.size / 2.0, shape.size)

	return rect.has_point(local_pos)
