extends Node2D

static var selected_maid: MaidResource
static var selected_table: Table = null
static var current_level: Level = null

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

func modify_multiplier(new_multiplier: int) -> void:
	var table_nodes: Array[Node] = get_tree().get_nodes_in_group("tables")
	for table in table_nodes:
		table.multiplier = new_multiplier
		print("multiplier = ", table.multiplier)

func modify_personality(personality: GlobalConstants.Personality) -> void:
	var customer_nodes: Array[Node] = get_tree().get_nodes_in_group("customers")
	for customer in customer_nodes:
		customer.customerPreference = personality
		print("personality = ", customer.customerPreference)

func patience_reset() -> void:
	var customer_nodes: Array[Node] = get_tree().get_nodes_in_group("customers")
	for customer in customer_nodes:
		customer.customerWaitTime.start() #resets waitTime
		print("wait time reset")



