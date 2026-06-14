extends Node

const CUSTOMER_SCENE = preload("uid://c45ii4qayngo0")

@export var level: LevelParam

@onready var customer_container: Node2D = %CustomerContainer
@onready var customer_timer: Timer = %CustomerTimer

func _ready() -> void:
	customer_timer.timeout.connect(_customer_come)
	_customer_come()
	
func _customer_come():
	if level.total_customer <= 0:
		print("no more customer")
		return
	var customer: Customer = CUSTOMER_SCENE.instantiate()
	customer.queue = customer_container
	customer_container.add_child(customer)
	customer_container.update_layout()
	
	level.total_customer -= 1
		
