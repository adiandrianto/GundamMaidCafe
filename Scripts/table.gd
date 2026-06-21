extends Area2D
class_name Table

const CUSTOMER_1_SITTING = preload("uid://j7qi843et0h6")
const CUSTOMER_2_SITTING = preload("uid://whsyp345tyiu")

@onready var maid_spot: Marker2D = %MaidSpot
@onready var customer_spot: Marker2D = %CustomerSpot
@onready var level: Node = get_tree().current_scene
@onready var sprite: Sprite2D = $Sprite
@onready var customer_order: TextureButton = %CustomerOrder
@onready var game_manager: GameManager = level.get_node("%GameManager")

var assigned_customer: Customer
var assigned_maid: Maid
var table_order: GlobalConstants.Food

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is Maid

func _drop_data(at_position: Vector2, data: Variant) -> void:
	assign_maid(data)

func assign_customer(customer: Customer):
	assigned_customer = customer
	customer.reparent(self, true)
	if customer.total_person == 1: # differentiate the texture based on jumlah orang
		customer.sprite.texture = CUSTOMER_1_SITTING
	else:
		customer.sprite.texture = CUSTOMER_2_SITTING
		
	customer.global_position = customer_spot.global_position
	customer.input_pickable = false
	table_order = GlobalConstants.Food.values().pick_random() #randomizes from globalconstants food enum

func _input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Table selected")
		var selected = GameManager.selected_maid
		GameManager.selected_table = self
		if selected and not assigned_maid:
			GameManager.selected_maid = null
			assign_maid(selected)


func assign_maid(maid: Maid):
	level._maid_come_to_table(maid, self)
	print("Assigned maid to table")
	await get_tree().create_timer(5.0).timeout
	table_order = GlobalConstants.Food.OMURICE #FOR TESTING PURPOSES, REMOVE WHEN READY
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
	customer_order.show()


func _on_customer_order_pressed() -> void:
	print("Order received")
	match table_order:
		GlobalConstants.Food.OMURICE:
			game_manager.instantiate_omurice_minigame()
		#GlobalConstants.Food.COFFEE:	
			#GameManager.instantiate_scene(GameManager.minigameScene_omurice)
		#GlobalConstants.Food.CREAMSODA:
			#GameManager.instantiate_scene(GameManager.minigameScene_omurice)
		#GlobalConstants.Food.PANCAKE:
			#GameManager.instantiate_scene(GameManager.minigameScene_omurice)
		#GlobalConstants.Food.PARFAIT:
			#GameManager.instantiate_scene(GameManager.minigameScene_omurice)
