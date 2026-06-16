extends Node

const CUSTOMER_SCENE = preload("uid://c45ii4qayngo0")
const TABLE_SCENE = preload("uid://caad16wajmi5r")

@export var level: LevelParam

@onready var table_area: Control = %TableArea
@onready var table_container: Node2D = %TableContainer
@onready var customer_container: Node2D = %CustomerContainer
@onready var customer_timer: Timer = %CustomerTimer
@onready var level_timer: Timer = %LevelTimer

@onready var close_sign: TextureRect = %CloseSign
var table_columns := 3

func _ready() -> void:
	customer_timer.timeout.connect(_customer_come)
	level_timer.timeout.connect(_level_finished)
	level_timer.wait_time = level.level_duration
	level_timer.start()
	_arrange_tables()
	_customer_come()

func _customer_come():
	if level.total_customer <= 0:
		print("no more customer")
		return
	var customer: Customer = CUSTOMER_SCENE.instantiate()
	customer_container.add_child(customer)
	customer_container.update_layout()
	
	level.total_customer -= 1

func _arrange_tables():
	var count = level.total_table

	if count <= 0:
		return

	var columns = ceili(sqrt(count))
	var rows = ceili(float(count) / columns)

	var rect := table_area.get_global_rect()

	var area_pos := rect.position
	var area_size := rect.size

	var cell_width: float = area_size.x / columns
	var cell_height: float = area_size.y / rows

	for row in range(rows):
		var start_idx = row * columns
		var items_in_row = min(columns, count - start_idx)

		# Center row terakhir jika tidak penuh
		var row_width = items_in_row * cell_width
		var start_x = (area_size.x - row_width) * 0.5

		for col in range(items_in_row):
			var idx = start_idx + col

			if idx >= count:
				break

			var table = TABLE_SCENE.instantiate()
			table_container.add_child(table)

			table.global_position = area_pos + Vector2( start_x + (col + 0.5) * cell_width, (row + 0.5) * cell_height )

func _level_finished():
	close_sign.texture  = preload("res://Assets/Visual/closed.png")
