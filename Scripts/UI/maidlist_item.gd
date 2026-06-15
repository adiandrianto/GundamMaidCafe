extends Panel

@onready var icon: TextureRect = $MaidIcon

func _get_drag_data(at_position: Vector2) -> Variant:
    if icon.texture == null:
        return
    var preview = duplicate()
    set_drag_preview(preview)
    return icon




