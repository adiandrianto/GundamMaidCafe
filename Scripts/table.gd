extends Control
class_name Table

@onready var maid_spot: Marker2D = %MaidSpot
@onready var customer_spot: Marker2D = %CustomerSpot

var assigned_customer: Customer
var assigned_maid: Maid

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is Maid

func _drop_data(at_position: Vector2, data: Variant) -> void:
	assign_maid(data)

func assign_customer(customer: Customer):
	assigned_customer = customer
	customer.reparent(self, true)
	customer.global_position = customer_spot.global_position
	customer.can_drag = false

func assign_maid(maid: Maid):
	assigned_maid = maid
	maid.global_position = maid_spot.global_position
	print("Assigned maid to table")
