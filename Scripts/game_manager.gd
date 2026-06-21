extends Node2D

static var selected_maid: Maid
static var selected_table: Table

static var minigameScene_omurice : PackedScene = preload("res://Scenes/MiniGame/Minigame O/minigame_o.tscn")
var scene_node

func instantiate_scene(scene: PackedScene):
    scene_node = scene.instantiate()
    add_child(scene_node)

func instantiate_omurice_minigame():
    instantiate_scene(minigameScene_omurice)
