extends Area2D
class_name Table

@onready var maid_spot: Marker2D = %MaidSpot
@onready var customer_spot: Marker2D = %CustomerSpot
@onready var level: Node = get_tree().current_scene

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
	customer.global_position = customer_spot.global_position
	customer.input_pickable = false

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
