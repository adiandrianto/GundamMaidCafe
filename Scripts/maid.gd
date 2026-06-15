extends Node2D
class_name Maid

# @onready var sprite: Sprite2D = %Sprite
@export var maidName: String
@export var maidPersonality: String


var table_entered: Table = null
var dragging := false
var can_drag := true

