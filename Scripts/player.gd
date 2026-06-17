extends CharacterBody2D
class_name Player

const SPEED := 500.0

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var anim: AnimatedSprite2D = $AnimatedSprite
var direction := Vector2.ZERO

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			navigation_agent.target_position = get_global_mouse_position()
			
func _physics_process(_delta: float) -> void:
	if navigation_agent.is_navigation_finished():
		velocity = Vector2.ZERO

		if anim:
			anim.play("default")

		move_and_slide()
		return

	var next_pos = navigation_agent.get_next_path_position()
	direction = global_position.direction_to(next_pos)
	velocity = direction * SPEED

	_update_animation(direction)
	move_and_slide()

func _update_animation(dir: Vector2):
	if not anim:
		return
	
	if abs(dir.x) > abs(dir.y):
		if dir.x > 0:
			anim.play("right")
		else:
			anim.play("left")
	else:
		if dir.y > 0:
			anim.play("down")
		else:
			anim.play("up")
		
	
	
