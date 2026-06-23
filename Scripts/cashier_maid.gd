extends CharacterBody2D
class_name CashierMaid

const SPEED := 300.0

signal arrived_at_target
# @onready var sprite: Sprite2D = %Sprite

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

## SOUND
@onready var footstep: AudioStreamPlayer = $Footstep

var direction: Vector2 = Vector2.ZERO
var collecting_payment: bool = false
var target_table: Array[Table] = []

func _init() -> void:
	pass #nanti untu init spritenya kl sudah ada bbrp

func _ready() -> void:
	await get_tree().process_frame

	if GameManager.current_level:
		global_position = GameManager.current_level.cashier_spot.global_position
	
func _physics_process(delta: float) -> void:
	if not GameManager.current_level:
		return
		
	if navigation_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		animation_player.play("idle")
		arrived_at_target.emit()
		process_mode = Node.PROCESS_MODE_PAUSABLE
		
		if global_position.is_equal_approx(GameManager.current_level.cashier_spot.global_position):
			pass
		elif not global_position.is_equal_approx(GameManager.current_level.cashier_spot.global_position) && not target_table.is_empty():
			await collect_payment(target_table.front())
		elif not global_position.is_equal_approx(GameManager.current_level.cashier_spot.global_position) && target_table.is_empty():
			navigation_agent.target_position = GameManager.current_level.cashier_spot.global_position
	else:
		process_mode = Node.PROCESS_MODE_ALWAYS
		var next_pos = navigation_agent.get_next_path_position()
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

func collect_payment(table: Table):
	collecting_payment = true
	animation_player.play("idle")
	target_table.pop_front()
	await get_tree().create_timer(1.0).timeout
	collecting_payment = false
	
	table.customer_leave()

func add_target(table: Table):
	target_table.push_back(table)
	if target_table.size() >= 1:
		navigation_agent.target_position = target_table.front().cashier_spot.global_position
	
#func walk_to_cashier():
	#if not targets.is_empty():
		#return
		#
	#navigation_agent.target_position = GameManager.current_level.cashier_spot.global_position
	#await arrived_at_target
	#animation_player.play("idle")

func play_footstep():
	footstep.play()
