extends Node2D
class_name OmeletObject

@export var tex: CompressedTexture2D
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	if tex:
		sprite.texture = tex
