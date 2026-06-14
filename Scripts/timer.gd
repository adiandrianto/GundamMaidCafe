extends TextureProgressBar

@onready var jarum: TextureRect = %JarumJam
@onready var timer: Timer = $Timer

func _process(delta: float) -> void:
	jarum.rotation_degrees = -(value / 100) * 360
	value = (timer.time_left / timer.wait_time) * 100
