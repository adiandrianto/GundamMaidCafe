extends Node2D

const COLLISION_MASK_OBJECT = 1

var screen_size
var object_being_dragged

func _ready() -> void:
	screen_size = get_viewport_rect()
	pass


func _process(delta) -> void:
	if object_being_dragged:
		var mouse_pos = get_global_mouse_position()
		object_being_dragged.position = mouse_pos


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_click"):
		print("inputA")
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		print("input")
		if event.pressed:
			var object = raycast_check_for_object()
			if object:
				print("drag")
				object.z_index += 1
				object_being_dragged = object
		else:
			var object = raycast_check_for_object()
			object_being_dragged = null


func raycast_check_for_object():
	print(" check for object")
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_OBJECT
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null


func _on_button_pressed() -> void:
	print("maouse")
