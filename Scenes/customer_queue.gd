extends Node2D

@export var spacing := 40

func update_layout():
	for i in range(get_child_count()):
		var customer = get_child(i)

		customer.position = Vector2(0, i * spacing)
		customer.input_pickable = (i == 0)
