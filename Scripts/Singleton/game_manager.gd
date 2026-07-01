extends Node2D

static var selected_maid: MaidResource
static var selected_table: Table = null
static var current_level: Level = null

var dragged_customer: Customer = null
var ignore_personality: bool = false
#static var minigameScene_omurice : PackedScene = preload("res://Scenes/MiniGame/Minigame O/minigame_o.tscn")
#var scene_node

func instantiate_order_scene(order_res: Order) -> MiniGame:
	var order = order_res.mini_game_scene.instantiate()

	current_level.mini_game_container.add_child(order)
	current_level.mini_game_played.append(order_res)
	return order
	#order.global_position = current_level.mini_game_container.global_position

#func instantiate_scene(scene: PackedScene):
	#scene_node = scene.instantiate()
	#add_child(scene_node)
#
#func instantiate_omurice_minigame():
	#instantiate_scene(minigameScene_omurice)
#func _input(event: InputEvent) -> void:
	#if Input.is_action_just_pressed("left_click"):
		#shake_maid_list()
		
func shake_maid_list():
	var tween := get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
	var obj = current_level.maid_list_ui
	tween.tween_property(obj, "rotation_degrees", -3, 0.05)
	tween.tween_property(obj, "rotation_degrees", 3, 0.05)
	tween.tween_property(obj, "rotation_degrees", -1, 0.05)
	tween.tween_property(obj, "rotation_degrees", 0, 0.05)


func modify_multiplier(new_multiplier: int) -> void:
	var table_nodes: Array[Node] = get_tree().get_nodes_in_group("tables")
	for table in table_nodes:
		table.multiplier = new_multiplier
		print("multiplier = ", table.multiplier)

func ignore_preference(duration: float) -> void:
	GameManager.ignore_personality = true
	await get_tree().create_timer(duration).timeout
	GameManager.ignore_personality = false
	#var customer_nodes: Array[Node] = get_tree().get_nodes_in_group("customers")
	#for customer in customer_nodes:
		#customer.customerPreference = personality
		#print("personality = ", customer.customerPreference)

func patience_reset() -> void:
	var customer_nodes: Array[Node] = get_tree().get_nodes_in_group("customers")
	for customer in customer_nodes:
		customer.restart_timer()
		print("wait time reset")
