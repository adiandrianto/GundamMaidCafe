extends TextureButton

@export var maidIndex: int
@export var maid_res : MaidResource

@onready var tooltip: PanelContainer = %Tooltip
@onready var name_label: RichTextLabel = %NameLabel
@onready var personality_label: RichTextLabel = %PersonalityLabel

@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar
@onready var color_rect: ColorRect = $ColorRect

func _ready() -> void:
	tooltip.hide()
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	texture_normal = maid_res.portrait
	color_rect.size = maid_res.portrait.get_size()
	color_rect.hide()

func _on_mouse_entered():
	name_label.text = maid_res.maid_name
	personality_label.text = GlobalConstants.Personality.keys()[maid_res.personality]
	tooltip.show()
	
func _on_mouse_exited():
	tooltip.hide()
	
func _pressed() -> void:
	if not maid_res:
		return
	
	if GameManager.selected_table == null :
		return
	
	get_tree().paused = false
	GameManager.selected_maid = maid_res
	print("Selected maid: ", maid_res.maid_name if maid_res.maid_name else "Maid #", maidIndex)

	var maid = GameManager.current_level.MAID_PREFAB.instantiate() as Maid
	maid.maid_resource = maid_res
	maid.global_position = GameManager.current_level.maid_spawn_point.global_position
	maid.freed.connect(_on_maid_freed, CONNECT_ONE_SHOT)
	GameManager.current_level.maid_container.add_child(maid)
	GameManager.current_level.maid_come_to_table(maid, GameManager.selected_table)
	color_rect.show()
	GameManager.selected_table = null
	
func _on_maid_freed():
	color_rect.hide()
