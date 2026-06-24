extends CharacterBody2D
class_name CashierMaid

enum State {
	IDLE,
	WALKING_TO_TABLE,
	COLLECTING_PAYMENT,
	RETURNING_TO_CASHIER
}

const SPEED := 300.0

signal arrived_at_target
# @onready var sprite: Sprite2D = %Sprite

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var footstep: AudioStreamPlayer = $Footstep


var state: State = State.IDLE
var direction: Vector2 = Vector2.ZERO
var target_table: Array[Table] = []

func _init() -> void:
	pass #nanti untu init spritenya kl sudah ada bbrp

func _ready() -> void:
	await get_tree().process_frame

	if GameManager.current_level:
		global_position = GameManager.current_level.cashier_spot.global_position
	
func _physics_process(_delta: float) -> void:
	if not GameManager.current_level:
		return
	
	match state:
		State.IDLE:
			velocity = Vector2.ZERO

		State.WALKING_TO_TABLE, State.RETURNING_TO_CASHIER:
			_move_to_target()

func _move_to_target() -> void:
	if navigation_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		animation_player.play("idle")
		arrived_at_target.emit()

		match state:
			State.WALKING_TO_TABLE:
				if !target_table.is_empty():
					state = State.COLLECTING_PAYMENT
					collect_payment(target_table.front())

			State.RETURNING_TO_CASHIER:
				state = State.IDLE

		return
		
	var next_pos := navigation_agent.get_next_path_position()

	direction = global_position.direction_to(next_pos)
	velocity = direction * SPEED

	_update_animation(direction)
	move_and_slide()
	
func _update_animation(dir: Vector2):
	if not animation_player:
		return

	if abs(dir.x) > abs(dir.y):
		if dir.x > 0:
			animation_player.play("right")
		else:
			animation_player.play("left")
	else:
		if dir.y > 0:
			animation_player.play("down")
		else:
			animation_player.play("up")

func collect_payment(table: Table) -> void:
	animation_player.play("idle")

	await get_tree().create_timer(0.8).timeout

	table.customer_leave()

	if !target_table.is_empty():
		target_table.pop_front()

	if target_table.is_empty():
		state = State.RETURNING_TO_CASHIER
		navigation_agent.target_position = GameManager.current_level.cashier_spot.global_position
	else:
		state = State.WALKING_TO_TABLE
		navigation_agent.target_position = target_table.front().cashier_spot.global_position

func add_target(table: Table) -> void:
	target_table.push_back(table)

	# Only start moving if we're currently idle
	if state == State.IDLE:
		state = State.WALKING_TO_TABLE
		navigation_agent.target_position = \
			target_table.front().cashier_spot.global_position
	
#func walk_to_cashier():
	#if not targets.is_empty():
		#return
		#
	#navigation_agent.target_position = GameManager.current_level.cashier_spot.global_position
	#await arrived_at_target
	#animation_player.play("idle")

func play_footstep():
	footstep.play()
