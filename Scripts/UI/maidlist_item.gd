extends TextureButton

@export var maidIndex: int
@export var maid : Maid


func _pressed() -> void:
	if not maid:
		return
	
	GameManager.selected_maid = maid
	print("Selected maid: ", maid.maidName if maid.maidName else "Maid #", maidIndex)
