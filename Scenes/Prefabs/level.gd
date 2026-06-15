extends Node

const CUSTOMER_SCENE = preload("uid://c45ii4qayngo0")

@export var level: LevelParam

@onready var customer_container: Node2D = %CustomerContainer
@onready var customer_timer: Timer = %CustomerTimer
@onready var level_timer: Timer = %LevelTimer

func _ready() -> void:
	customer_timer.timeout.connect(_customer_come)
	level_timer.timeout.connect(_level_finished)
	level_timer.wait_time = level.level_duration
	level_timer.start()
	_customer_come()
	
func _customer_come():
	if level.total_customer <= 0:
		print("no more customer")
		return
	var customer: Customer = CUSTOMER_SCENE.instantiate()
	customer_container.add_child(customer)
	customer_container.update_layout()
	
	level.total_customer -= 1
		
func _level_finished():
	pass # scoring
