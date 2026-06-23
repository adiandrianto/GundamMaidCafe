extends Node2D

@export var spacing := 64

func update_layout():
	for i in range(get_child_count()):
		var customer = get_child(i) as Customer
		
		if not customer.put_down.is_connected(_back_to_queue):
			customer.put_down.connect(_back_to_queue.bind(customer))
			
		if customer.dragging: 
			continue
		
		customer.z_index = get_child_count() - i
		customer.position = Vector2(0, -(i * spacing))
		customer.input_pickable = (i == 0)

func _back_to_queue(customer: Customer):
	move_child(customer, 0) # move to front of queue
	update_layout()
