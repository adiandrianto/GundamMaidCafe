extends MarginContainer


func _notification(what: int) -> void:
	if what == Node.NOTIFICATION_DRAG_END:
		if not is_drag_successful():
			get_viewport().gui_cancel_drag()
