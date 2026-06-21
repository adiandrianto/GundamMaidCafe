extends CharacterBody2D
class_name Maid

signal arrived_at_table
# @onready var sprite: Sprite2D = %Sprite
@export var maid_resource: MaidResource

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var anim: AnimatedSprite2D = $AnimatedSprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var service_timer: Timer = $ServiceTimer

var table_entered: Table = null
var direction: Vector2 = Vector2.ZERO
var dragging: bool = false
var can_drag: bool = true

var customer_serviced: Customer = null
var in_service: bool = false

const SPEED := 300.0

func _init() -> void:
	pass #nanti untu init spritenya kl sudah ada bbrp

func _ready() -> void:
	progress_bar.hide()
	service_timer.timeout.connect(_back_to_station)
	
func _process(delta: float) -> void:
	if in_service:
		progress_bar.value = service_timer.time_left / service_timer.wait_time
	
func _physics_process(delta: float) -> void:
	if navigation_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		arrived_at_table.emit()
		take_order()
		
		if anim:
			anim.play("default")
			animation_player.play("idle")

		move_and_slide()
		return

	var next_pos = navigation_agent.get_next_path_position()
	direction = global_position.direction_to(next_pos)
	velocity = direction * SPEED
	
	animation_player.play("move")
	_update_animation(direction)
	move_and_slide()

func walk_to_table(table: Table):
	navigation_agent.target_position = table.maid_spot.global_position
	await arrived_at_table
	
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

func service_table(table: Table):
	#table.assigned_maid = self
	service_timer.wait_time = maid_resource.service_duration
	progress_bar.show()
	in_service = true
	
func _back_to_station():
	animation_player.play("back_to_station")

func take_order():
	pass
	
