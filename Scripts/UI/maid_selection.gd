extends Control
class_name MaidSelectWindow

@export var table_ordered: Table = null
@onready var portrait_container: GridContainer = %PortraitContainer

func _ready() -> void:
	for maid_res in GlobalConstants.maid_roster:
		var portrait = TextureButton.new()
		portrait.texture_normal = maid_res.portrait
		portrait_container.add_child(portrait)
		portrait.pressed.connect(_on_pressed.bind(maid_res))
		
func _on_pressed(maid_res: MaidResource):
	var maid = GlobalConstants.MAID_PREFAB.instantiate() as Maid
	maid.maid_resource = maid_res
	maid.global_position = GameManager.current_level.maid_spawn_point.global_position
	GameManager.current_level.mini_game_container.add_child(maid)
	self.hide()
	await GameManager.current_level.maid_come_to_table(maid, table_ordered)
	table_ordered.order_from_menu()
	queue_free()

	
	
