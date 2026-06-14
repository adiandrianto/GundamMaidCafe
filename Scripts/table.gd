extends Node2D
class_name Table

@onready var maid_spot: Marker2D = %MaidSpot
@onready var customer_spot: Marker2D = %CustomerSpot

var assigned_customer: Customer
var assigned_maid: Maid

func assign_customer(customer: Customer):
	assigned_customer = customer
	customer.global_position = customer_spot.global_position

func assign_maid(maid: Maid):
	assigned_maid = maid
	maid.global_position = maid_spot.global_position
