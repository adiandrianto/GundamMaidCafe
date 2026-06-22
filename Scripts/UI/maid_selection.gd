extends Control
class_name MaidSelectWindow

@export var table_ordered: Table = null
@onready var portrait_container: GridContainer = %PortraitContainer

@onready var tooltip: PanelContainer = %Tooltip
@onready var name_label: RichTextLabel = %NameLabel
@onready var personality_label: RichTextLabel = %PersonalityLabel

func _ready() -> void:
	get_tree().paused = true
	tooltip.hide()
	
	for maid_res in GlobalConstants.maid_roster:
		var portrait = TextureButton.new()
		portrait.texture_normal = maid_res.portrait
		portrait_container.add_child(portrait)
		
		portrait.mouse_entered.connect(_on_portrait_mouse_entered.bind(maid_res))
		portrait.mouse_exited.connect(func(): tooltip.hide())
		portrait.pressed.connect(_on_pressed.bind(maid_res))

func _exit_tree() -> void:
	get_tree().paused = false
	
func _on_pressed(maid_res: MaidResource):
	var maid = GameManager.current_level.MAID_PREFAB.instantiate() as Maid
	maid.maid_resource = maid_res
	maid.global_position = GameManager.current_level.maid_spawn_point.global_position
	GameManager.current_level.mini_game_container.add_child(maid)
	self.hide()
	GameManager.current_level.maid_come_to_table(maid, table_ordered)
	queue_free()

func _on_portrait_mouse_entered(maid_res: MaidResource):
	name_label.text = maid_res.maid_name
	personality_label.text = GlobalConstants.Personality.keys()[maid_res.personality]
	tooltip.show()
	
	
