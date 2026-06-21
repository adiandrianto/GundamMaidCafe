extends Area2D
class_name Customer

const CUSTOMER_1 = preload("uid://dkoxvrdk6qc28")
const CUSTOMER_2 = preload("uid://b3o2wyhstfrxj")

signal put_down

@export var dialogue_popup: Panel

@onready var maid_popup: TextureButton = $UI/MaidPrompt
@onready var sprite: Sprite2D = %Sprite

var table_entered: Array[Table] = []
var dragging: bool = false
var customerPreference: GlobalConstants.Personality
var request_maid: bool = false
var order: Order

var total_person: int = 0

func _ready() -> void:
	_randomize_customer_number()
	
	order = GlobalConstants.menu_arr.pick_random()
	if sprite.material:
		sprite.material = sprite.material.duplicate()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var clicked = get_area_under_mouse()

			if clicked == self && clicked.input_pickable == true:
				begin_drag()

		elif event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
			end_drag()

func get_area_under_mouse() -> Area2D:
	var space = get_world_2d().direct_space_state

	var query := PhysicsPointQueryParameters2D.new()
	query.position = get_global_mouse_position()
	query.collide_with_areas = true

	var results = space.intersect_point(query)

	if results.is_empty() || results[0].collider is not Customer :
		return null

	return results[0].collider

func _process(_delta):
	if dragging:
		global_position = get_global_mouse_position()

func begin_drag():
	dragging = true
	give_outline()

func end_drag():
	if not dragging:
		return
	dragging = false
	remove_outline()
	if table_entered:
		table_entered[0].assign_customer(self)
		request_maid = true
		popup_maid()
	else:
		emit_signal("put_down")
	
func give_outline():
	if not sprite:
		return
	var mat := sprite.material as ShaderMaterial
	if mat:
		mat.set_shader_parameter("width", 2)

func remove_outline():
	if not sprite:
		return

	var mat := sprite.material as ShaderMaterial
	if mat:
		mat.set_shader_parameter("width", 0)

func _randomize_customer_number() -> void:
	total_person = [1,2].pick_random()
	
	if total_person == 1:
		sprite.texture = CUSTOMER_1
	else:
		sprite.texture = CUSTOMER_2
		
func _on_area_entered(area: Area2D) -> void:
	if area is not Table:
		return
	table_entered.push_front(area)

func _on_area_exited(area: Area2D) -> void:
	if area is Table:
		if table_entered.has(area):
			table_entered.erase(area)

func _on_maid_prompt_pressed() -> void:
	maid_popup.hide()
	print("ordering")
	dialogue_popup.show()
	await get_tree().create_timer(1.0).timeout
	dialogue_popup.hide()
	
	var maid_select_panel = GlobalConstants.MAID_SELECTION.instantiate() as MaidSelectWindow
	maid_select_panel.table_ordered = table_entered[0]
	GameManager.current_level.mini_game_container.add_child(maid_select_panel)

func popup_maid() -> void:
	if request_maid == true:
		maid_popup.show()
		print("maid request")
