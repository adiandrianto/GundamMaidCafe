extends RigidBody2D
class_name Coin

@export var follow_speed: int = 1200
@export var arc_height: int = -100
@export var value: int = 10

@onready var area_2d: Area2D = $Area2D

func _ready() -> void:
	print(global_position)
	area_2d.area_entered.connect(_on_area_entered)
	_apply_initial_impulse()
	
#func _physics_process(_delta):
	#var distance = global_position.distance_to(GameManager.current_level.cashier.global_position)
	#if distance < collect_distance && !collected:
		#_collect_kati()

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	gravity_scale = 0.0
	var dir = (GameManager.current_level.cashier.global_position - global_position).normalized()
	var target_velocity = dir * follow_speed
	state.linear_velocity = state.linear_velocity.lerp(target_velocity, 0.05)

func _apply_initial_impulse() -> void:
	pass
	apply_impulse(Vector2(-800,-100))#(Vector2(randf_range(-2000, 2000), arc_height))

func _on_area_entered(area: Area2D):
	if area is not Cashier:
		return
	
	GameManager.current_level.add_income(value)
	queue_free()
