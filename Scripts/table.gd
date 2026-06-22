extends Area2D
class_name Table

const CUSTOMER_1_SITTING = preload("uid://j7qi843et0h6")
const CUSTOMER_2_SITTING = preload("uid://whsyp345tyiu")

@onready var maid_spot: Marker2D = %MaidSpot
@onready var customer_spot: Marker2D = %CustomerSpot
@onready var level: Node = get_tree().current_scene
@onready var sprite: Sprite2D = $Sprite
@onready var order_icon: TextureButton = %OrderIcon
@onready var eating_timer: Timer = $EatingTimer

var assigned_customer: Customer
var assigned_maid: Maid

#func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	#return data is Maid
#
#func _drop_data(at_position: Vector2, data: Variant) -> void:
	#assign_maid(data)
func _ready() -> void:
	eating_timer.timeout.connect(_customer_leave)
	order_icon.hide()

func assign_customer(customer: Customer):
	assigned_customer = customer
	customer.reparent(self, true)
	if customer.total_person == 1: # differentiate the texture based on jumlah orang
		customer.sprite.texture = CUSTOMER_1_SITTING
	else:
		customer.sprite.texture = CUSTOMER_2_SITTING
		
	customer.global_position = customer_spot.global_position
	customer.input_pickable = false

#func _input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	#if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		#print("Table selected")
		#var selected = GameManager.selected_maid
		#GameManager.selected_table = self
		#if selected and not assigned_maid:
			#GameManager.selected_maid = null
		#assign_maid(selected)

func order_from_menu():
	if !assigned_customer:
		print("no customer assigned to table")
		return
		
	_show_order_icon()

func _show_order_icon():
	print(assigned_customer.order)
	order_icon.texture_normal = assigned_customer.order.icon
	order_icon.show()
	order_icon.pressed.connect(_on_order_icon_pressed)

func _on_order_icon_pressed():
	order_icon.pressed.disconnect(_on_order_icon_pressed)
	order_icon.hide()
	var mini_game = GameManager.instantiate_order_scene(assigned_customer.order)
	mini_game.finished.connect(_customer_start_eating)
	
func _customer_leave():
	print("customer finish eating")
	assigned_customer.queue_free()
	assigned_customer = null
	
	if assigned_maid:
		assigned_maid.back_to_station()

func _customer_start_eating(_score):
	eating_timer.start()

#func assign_maid(maid: Maid):
	#print("Assigned maid to table")
	#
	## pesan jika ada maid yang service dan ada pelanggan
	#if assigned_maid && assigned_customer:
		#assigned_customer.order_from_menu()
		
	#table_order = GlobalConstants.Food.OMURICE #FOR TESTING PURPOSES, REMOVE WHEN READY
	#match table_order:
	#	GlobalConstants.Food.OMURICE:
	#		customer_order.texture_normal = 
	#	GlobalConstants.Food.COFFEE:	
	#		customer_order.texture_normal = 
	#	GlobalConstants.Food.CREAMSODA:
	#		customer_order.texture_normal = 
	#	GlobalConstants.Food.PANCAKE:
	#		customer_order.texture_normal = 
	#	GlobalConstants.Food.PARFAIT:
	#		customer_order.texture_normal = 
	#customer_order.show()

#func _on_customer_order_pressed() -> void:
	#print("Order received")
	#match table_order:
		#GlobalConstants.Food.OMURICE:
			#game_manager.instantiate_omurice_minigame()
		#GlobalConstants.Food.COFFEE:	
			#GameManager.instantiate_scene(GameManager.minigameScene_omurice)
		#GlobalConstants.Food.CREAMSODA:
			#GameManager.instantiate_scene(GameManager.minigameScene_omurice)
		#GlobalConstants.Food.PANCAKE:
			#GameManager.instantiate_scene(GameManager.minigameScene_omurice)
		#GlobalConstants.Food.PARFAIT:
			#GameManager.instantiate_scene(GameManager.minigameScene_omurice)
