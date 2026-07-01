extends Node2D
class_name MaidSelectWindow

const MAIDLIST_ITEM = preload("uid://bttcbb83uabeq")

@export var table_ordered: Table = null
@onready var portrait_container: GridContainer = %PortraitContainer
@onready var label: Label = %Label
@onready var tooltip: PanelContainer = %Tooltip
#@onready var name_label: RichTextLabel = %NameLabel
@onready var personality_label: RichTextLabel = %PersonalityLabel

func _ready() -> void:
	global_position = table_ordered.global_position + Vector2(0, -100)
	get_tree().paused = true
	tooltip.hide()

	label.text = table_ordered.assigned_customer.customer_line

	for maid_res in GlobalConstants.maid_roster:
		var maid = MAIDLIST_ITEM.instantiate() as MaidlistItem
		maid.maid_res = maid_res
		portrait_container.add_child(maid)
		#var portrait = TextureButton.new()
		#portrait.texture_normal = maid_res.portrait
		#portrait.texture_hover = maid_res.portrait_hovered
		#portrait_container.add_child(portrait)
		
		maid.mouse_entered.connect(_on_portrait_mouse_entered.bind(maid_res))
		maid.mouse_exited.connect(func(): tooltip.hide())
		maid.pressed.connect(_on_pressed.bind(maid_res))

func _exit_tree() -> void:
	get_tree().paused = false
	
func _on_pressed(maid_res: MaidResource):
	var maid = GameManager.current_level.MAID_PREFAB.instantiate() as Maid
	maid.maid_resource = maid_res
	maid.global_position = GameManager.current_level.maid_spawn_point.global_position
	self.hide()
	
	GameManager.current_level.maid_container.add_child(maid)
	GameManager.current_level.maid_come_to_table(maid, table_ordered)
	GameManager.current_level.set_level_dark(false)
	$Select.play()
	await $Select.finished
	
	queue_free()

func _on_portrait_mouse_entered(maid_res: MaidResource):
	$Hover.play()
	personality_label.text = GlobalConstants.Personality.keys()[maid_res.personality]
	tooltip.show()
	
	
