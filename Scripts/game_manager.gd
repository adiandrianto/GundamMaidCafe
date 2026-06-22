extends Node2D

#static var selected_maid: Maid
static var selected_table: Table
static var current_level: Level = null

#static var minigameScene_omurice : PackedScene = preload("res://Scenes/MiniGame/Minigame O/minigame_o.tscn")
#var scene_node

func instantiate_order_scene(order_res: Order) -> MiniGame:
	var order = order_res.mini_game_scene.instantiate()

	current_level.mini_game_container.add_child(order)
	return order
	#order.global_position = current_level.mini_game_container.global_position

#func instantiate_scene(scene: PackedScene):
	#scene_node = scene.instantiate()
	#add_child(scene_node)
#
#func instantiate_omurice_minigame():
	#instantiate_scene(minigameScene_omurice)
