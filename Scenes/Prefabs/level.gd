extends Node

const CUSTOMER_PREFAB = preload("uid://c45ii4qayngo0")
const TABLE_PREFAB = preload("uid://caad16wajmi5r")
const MAID_PREFAB = preload("uid://cwcitmbloxqrx")

@export var level: LevelParam

@onready var table_area: Control = %TableArea
@onready var table_container: Node = %TableContainer
@onready var customer_container: Node2D = %CustomerContainer
@onready var customer_timer: Timer = %CustomerTimer
@onready var level_timer: Timer = %LevelTimer
@onready var maid_spawn_point: Marker2D = %MaidSpawnPoint

@onready var close_sign: TextureRect = %CloseSign
var table_columns: int = 3

var selected_table: Table = null

func _ready() -> void:
	customer_timer.timeout.connect(_customer_come)
	level_timer.timeout.connect(_level_finished)
	level_timer.wait_time = level.level_duration
	level_timer.start()
	_arrange_tables()
	_customer_come()
	
	selected_table = table_container.get_child(2)
	#await get_tree().create_timer(1).timeout
	#_maid_come_to_table(MAID_PREFAB.instantiate(), selected_table)

func _customer_come():
	if level.total_customer <= 0:
		print("no more customer")
		return
	var customer: Customer = CUSTOMER_PREFAB.instantiate()
	customer.z_index = -customer_container.get_child_count()
	customer_container.add_child(customer)
	customer_container.update_layout()
	
	level.total_customer -= 1

func _arrange_tables():
	var count = level.total_table

	if count <= 0:
		return

	var columns = ceili(sqrt(count))
	var rows = ceili(float(count) / columns)

	var rect: Rect2 = table_area.get_global_rect()

	var area_pos: Vector2 = rect.position
	var area_size: Vector2 = rect.size

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

			var table = TABLE_PREFAB.instantiate()
			table_container.add_child(table)
			table.global_position = area_pos + Vector2( start_x + (col + 0.5) * cell_width, (row + 0.5) * cell_height )
	%NavRegion.bake_navigation_polygon()

func _maid_come_to_table(maid: Maid, table: Table, ) -> void:
	if selected_table == null: 
		return

	#maid_spawn_point.add_child(maid)
	maid.global_position = maid_spawn_point.global_position
	maid.walk_to_table(table)
	
func _level_finished():
	close_sign.texture  = preload("uid://dh58rpyvq2rcy")
