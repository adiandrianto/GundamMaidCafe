extends Area2D
class_name Table

const CUSTOMER_ANIMATED_1 = preload("uid://ssw78jxehmyu")
const CUSTOMER_ANIMATED_2 = preload("uid://b3evsf67w634m")

const COIN = preload("uid://bo30edhdjf15p")

@onready var maid_spot: Marker2D = %MaidSpot
@onready var customer_spot: Marker2D = %CustomerSpot
@onready var cashier_spot: Marker2D = %CashierSpot

@onready var level: Node = get_tree().current_scene

@onready var sprite: Sprite2D = $Sprite
@onready var order_icon: TextureButton = %OrderIcon
@onready var payment_icon: TextureButton = %PaymentIcon
@onready var eating_timer: Timer = $EatingTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var coin_sprite: Sprite2D = $CoinSprite

var assigned_customer: Customer
var assigned_maid: Maid

var bill: int = 0

#func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	#return data is Maid
##
#func _drop_data(at_position: Vector2, data: Variant) -> void:
	#assign_maid(data)
	
func _ready() -> void:
	eating_timer.timeout.connect(_request_bill)
	order_icon.hide()
	payment_icon.hide()
	coin_sprite.hide()

func assign_customer(customer: Customer):
	assigned_customer = customer
	customer.reparent(self, true)
	customer.animated_sprite.play("sitting")
	customer.global_position = customer_spot.global_position
	customer.input_pickable = false
	$CustomerSit.play()

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
	
	await get_tree().create_timer(0.8).timeout
	_show_order_icon()

func _show_order_icon():
	order_icon.texture_normal = assigned_customer.order.icon
	animation_player.play("order_appear")
	order_icon.pressed.connect(_on_order_icon_pressed, CONNECT_ONE_SHOT)

func _on_order_icon_pressed():
	animation_player.play("order_disappear")
	var mini_game = GameManager.instantiate_order_scene(assigned_customer.order)
	mini_game.finished.connect(_on_mini_game_finished)
	
func customer_leave():
	#var coin = COIN.instantiate()
	#coin.value = bill
	#coin.global_position = global_position
	#get_tree().add_child(coin)
	
	#add table bill to income and reset to 0
	GameManager.current_level.add_income(bill)
	bill = 0
	#animasi bill
	animation_player.play("payment_done")
	
	assigned_customer.leave()
	
	if assigned_maid:
		assigned_maid.back_to_station()

func _on_mini_game_finished(score):
	bill += score
	eating_timer.start()
	assigned_customer.animated_sprite.play("eating")

func _request_bill():
	assigned_customer.animated_sprite.play("sitting")
	animation_player.play("payment_appear")
	payment_icon.pressed.connect(_on_payment_icon_pressed, CONNECT_ONE_SHOT)

func _on_payment_icon_pressed():
	var cashier_maid: CashierMaid = get_tree().get_first_node_in_group("cashier_maid")
	cashier_maid.add_target(self)
	animation_player.play("payment_disappear")

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
