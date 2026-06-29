extends Node
class_name Level

const CUSTOMER_PREFAB = preload("uid://c45ii4qayngo0")
const TABLE_PREFAB = preload("uid://caad16wajmi5r")
const MAID_PREFAB= preload("uid://cwcitmbloxqrx")
const MAID_SELECTION = preload("uid://baju6xbb2lbsx")

const POURING_TEA_MINI_GAME: PackedScene = preload("uid://bcoafo2w7e5cl")
const SHAKE_RHYTHM_MINI_GAME: PackedScene = preload("uid://bvnuvd6l7klfg")
const OMELETTE_MINI_GAME: PackedScene = preload("uid://b6voidpbr24bo")

@export var level_param: LevelParam

@onready var goal_label: Label = %GoalLabel
@onready var income_label: Label = %IncomeLabel
@onready var blind: ColorRect = %Blind

@onready var table_area: Control = %TableArea
@onready var table_container: Node = %TableContainer
@onready var customer_container: Node2D = %CustomerContainer
@onready var customer_timer: Timer = %CustomerTimer
@onready var level_timer: Timer = %LevelTimer

@onready var maid_list_ui: MarginContainer = %MaidList
@onready var maid_spawn_point: Marker2D = %MaidSpawnPoint
@onready var maid_container: Node2D = %MaidContainer

@onready var mini_game_container: Control = %MiniGameContainer

@onready var close_sign: TextureRect = %CloseSign

@onready var cashier_spot: Marker2D = $CashierSpot
@onready var cashier: Cashier = %Cashier

@onready var welcome_panel: PanelContainer = $UILayer/Tutorial/Welcome
@onready var tutorial_panel: Control = %TutorialPanel
@onready var tutorial_label_1: Label = %TutorialLabel1
@onready var tutorial_label_2: Label = %TutorialLabel2
@onready var tutorial_label_3: Label = %TutorialLabel3


var table_columns: int = 3
var income: int = 0
var mini_game_played: Array[Order] = []

static var selected_table: Table = null
static var selected_maid: Maid = null

func _ready() -> void:
	_init_hud()
	GameManager.current_level = self
	customer_timer.timeout.connect(_customer_come)
	level_timer.timeout.connect(_level_finished)
	level_timer.wait_time = level_param.level_duration
	level_timer.start()
	_arrange_tables()
	_hide_tutorial()
	
	await get_tree().create_timer(0.5).timeout
	
	_customer_come()
	
	if level_param.is_tutorial:
		welcome_panel.show()
		_tween_appear(welcome_panel)
		level_timer.set_paused(true)
		customer_timer.set_paused(true)

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var hovered = get_viewport().gui_get_hovered_control()
		if hovered:
			print("Hovered:", hovered.get_path())
			
func _hide_tutorial():
	blind.hide()
	welcome_panel.hide()
	tutorial_panel.hide()
	
func _init_hud():
	goal_label.text = str(level_param.total_goal)
	income_label.text = "0"
	
func add_income(sum: int):
	income += sum
	income_label.text = str(income)
	
func _customer_come():
	if level_param.total_customer <= 0:
		print("no more customer")
		customer_container.update_layout()
		return

	var customer = CUSTOMER_PREFAB.instantiate() as Customer
	customer_container.add_child(customer)
	#customer.z_index -= customer_container.get_child_count()
	customer_container.update_layout()
	
	level_param.total_customer -= 1

func _arrange_tables():
	var count = level_param.total_table

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

func maid_come_to_table(maid: Maid, table: Table) -> void:
	maid.global_position = maid_spawn_point.global_position
	await maid.walk_to_table(table)
	
	maid.take_order(table)
	
func _level_finished():
	var mini_game_played_names: Array[String] = []
	#implement here for scoring
	
	close_sign.texture  = preload("uid://dh58rpyvq2rcy")

func _tween_appear(obj: Object):
	var tween := get_tree().create_tween()
	obj.set("scale", 0.0)
	tween.tween_property(obj, "scale", Vector2(1.2, 1.2), 0.12)
	tween.tween_property(obj, "scale", Vector2(1.0, 1.0), 0.08)

func _tween_disappear(obj: Object):
	var tween := get_tree().create_tween()
	tween.tween_property(obj, "scale", Vector2(1.1, 1.1), 0.05)
	tween.tween_property(obj, "scale", Vector2(0.0, 0.0), 0.08)
	
func _on_button_pressed() -> void:
	level_timer.set_paused(false)
	customer_timer.set_paused(false)
	welcome_panel.hide()
	tutorial_panel.show()
	_tween_appear(tutorial_panel)
	show_tutorial_text(1)

func show_tutorial_text(num: int):
	var panel := $UILayer/Tutorial/TutorialPanel/PanelContainer
	for child in panel.get_children():
		child.hide()
	
	if num < 1:
		_tween_disappear(tutorial_panel)
		return
		
	if num >= 1 and num < panel.get_child_count() + 1:
		panel.get_child(num-1).show()
		_type_text(panel.get_child(num-1))

func _type_text(label: Label):
	label.visible_ratio = 0.0

	var tween := create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)

	# 0.04 sec per character
	var duration := label.text.length() * 0.02
	tween.tween_property(label, "visible_ratio", 1.0, duration)
	
func set_level_dark(value: bool):
	blind.visible = value
