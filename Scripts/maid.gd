extends CharacterBody2D
class_name Maid

signal arrived_at_table
signal freed

@export var maid_resource: MaidResource

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var progress_bar: ProgressBar = $ProgressBar
#@onready var service_timer: Timer = $ServiceTimer
@onready var sprite: Sprite2D = %Sprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer

## SOUND
@onready var footstep: AudioStreamPlayer = $Footstep

var direction: Vector2 = Vector2.ZERO
var dragging: bool = false
var can_drag: bool = true

var table_serviced: Table = null
var in_service: bool = false

const SPEED := 300.0

func _enter_tree() -> void:
	pass
	
func _ready() -> void:
	progress_bar.hide()
	sprite.texture = maid_resource.sprite
	
#func _process(delta: float) -> void:
	#if in_service:
		#progress_bar.value = (service_timer.time_left / service_timer.wait_time)
	
func _physics_process(delta: float) -> void:
	if in_service:
		process_mode = Node.PROCESS_MODE_PAUSABLE
		return
		
	if navigation_agent.is_navigation_finished() && not in_service:
		process_mode = Node.PROCESS_MODE_PAUSABLE
		velocity = Vector2.ZERO
		arrived_at_table.emit()
		#take_order()
	else:
		process_mode = Node.PROCESS_MODE_ALWAYS
		var next_pos = navigation_agent.get_next_path_position()
		direction = global_position.direction_to(next_pos)
		velocity = direction * SPEED

		_update_animation(direction)
		move_and_slide()

func walk_to_table(table: Table):
	# if in service maid wont be available to be picked by other table
	if GlobalConstants.available_maids.has(maid_resource):
		GlobalConstants.available_maids.erase(maid_resource)
		
	navigation_agent.target_position = table.maid_spot.global_position
	await arrived_at_table
	service_table(table)
	
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

func service_table(table: Table):
	animation_player.play("idle")
	
	table_serviced = table
	table.assigned_maid = self
	
	#if maid match customer preference table_bill nambah 1.5 kali
	if table.assigned_maid.maid_resource.personality == table.assigned_customer.customer_preference:
		print("matched")
		# multiplier dihandle di table.gd
		table.pop_sprite.texture = table.HEART_SPRITE
		table.animation_player.play("sprite_pop")
	
	table.show_matched_preference(table.assigned_maid.maid_resource.personality == table.assigned_customer.customer_preference)
	#service_timer.wait_time = maid_resource.service_duration
	#service_timer.start()
	#progress_bar.show()
	
	in_service = true
	
func back_to_station():
	if not GlobalConstants.available_maids.has(maid_resource):
		GlobalConstants.available_maids.append(maid_resource)
		
	animation_player.play("back_to_station")
	freed.emit()

func take_order(table: Table):
	table.order_from_menu()
