extends CharacterBody2D
class_name Maid

# @onready var sprite: Sprite2D = %Sprite
@export var maidName: String
@export var maidPersonality: int
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var anim: AnimatedSprite2D = $AnimatedSprite

var table_entered: Table = null
var direction := Vector2.ZERO
var dragging := false
var can_drag := true

const SPEED := 400.0

func _physics_process(delta: float) -> void:
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

func walk_to_table(table: Table):
	navigation_agent.target_position = table.maid_spot.global_position
	
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
