extends Area2D
class_name Customer

var menu_arr: Array[Order] = [
	preload("uid://b57j63twpn1ox"),
	preload("uid://b175xvpa2jldc"),
	preload("uid://ckkrn7uylotqv"),
]

const ONE_CUSTOMER = preload("uid://clbhuisd0ei83")
const TWO_CUSTOMER = preload("uid://c18ny6rqyx556")

signal put_down

@export var dialogue_popup: Panel
@export var customerWaitTime: Timer

@onready var maid_popup: TextureButton = $UI/MaidPrompt
@onready var animated_sprite: AnimatedSprite2D = %Sprite
@onready var animation_player: AnimationPlayer = $Animation
@onready var preference_label: Label = %PreferenceLabel
@onready var wait_progress_bar: TextureProgressBar = $WaitProgressBar
@onready var wait_timer: Timer = $WaitTimer

var customer_preference: GlobalConstants.Personality = GlobalConstants.Personality.values().pick_random()
var customer_line: String 
var wait_time: float = 10.0
var table_entered: Array[Table] = []
var dragging: bool = false
var request_maid: bool = false
var order: Order
var waited_too_long: bool = false

var total_person: int = 0

func _ready() -> void:
	wait_timer.timeout.connect(leave, CONNECT_ONE_SHOT)
	_randomize_customer_number()
	customerWaitTime.timeout.connect(_unsatisfied_leave)
	
	$UI/MaidPrompt.hide()
	$UI/Dialogue.hide()
	
	customer_line = GlobalConstants.get_random_line(customer_preference)
	preference_label.text = customer_line
	
	order = menu_arr.pick_random()
	
	if animated_sprite.material:
		animated_sprite.material = animated_sprite.material.duplicate()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var clicked = get_area_under_mouse()

			if clicked == self && clicked.input_pickable == true:
				begin_drag()

		elif event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
			end_drag()

func restart_timer():
	wait_timer.stop()
	wait_timer.start()
	print(wait_timer.time_left)
	
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
	
	wait_progress_bar.value = wait_timer.time_left / wait_timer.wait_time

func begin_drag():
	dragging = true
	GameManager.dragged_customer = self
	give_outline()

func end_drag():
	if not dragging:
		return
		
	dragging = false
	GameManager.dragged_customer = null
	remove_outline()
	if table_entered:
		if table_entered[0].assigned_customer != null:
			emit_signal("put_down")
			return
		table_entered[0].assign_customer(self)
		wait_progress_bar.hide()
		wait_timer.stop()
		request_maid = true
		popup_maid()
		if GameManager.current_level.level_param.is_tutorial:
			GameManager.current_level.show_tutorial_text()
	else:
		emit_signal("put_down")
	
func give_outline():
	if not animated_sprite:
		return
	var mat := animated_sprite.material as ShaderMaterial
	if mat:
		mat.set_shader_parameter("width", 3)

func remove_outline():
	if not animated_sprite:
		return

	var mat := animated_sprite.material as ShaderMaterial
	if mat:
		mat.set_shader_parameter("width", 0)

func _randomize_customer_number() -> void:
	total_person = [1,2].pick_random()
	
	if total_person == 1:
		animated_sprite.sprite_frames = ONE_CUSTOMER
	else:
		animated_sprite.sprite_frames = TWO_CUSTOMER
		
	animated_sprite.play("idle")
	
func _on_area_entered(area: Area2D) -> void:
	if area is not Table:
		return
	table_entered.push_front(area)

func _on_area_exited(area: Area2D) -> void:
	if area is Table:
		if table_entered.has(area):
			table_entered.erase(area)

func _on_maid_prompt_pressed() -> void:
	if GlobalConstants.available_maids.is_empty(): #kl semua maid blm available
		print("no available maid")
		$Error.play()
		GameManager.shake_maid_list()
		return
		
	GameManager.selected_table = table_entered[0]
	maid_popup.hide()
	#print("ordering")
	#dialogue_popup.show()
	#get_tree().paused = true
	#await get_tree().create_timer(5.0).timeout
	#dialogue_popup.hide()

	var maid_select_panel = GameManager.current_level.MAID_SELECTION.instantiate() as MaidSelectWindow
	maid_select_panel.table_ordered = table_entered[0]
	GameManager.current_level.mini_game_container.add_child(maid_select_panel)
	GameManager.current_level.set_level_dark(true)

func popup_maid() -> void:
	if request_maid == true:
		animation_player.play("maid_icon_appear")

func leave():
	animation_player.play("leave")
	GameManager.current_level.customer_inside -= 1
