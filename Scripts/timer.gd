extends TextureProgressBar

@onready var jarum: TextureRect = %JarumJam
@onready var timer: Timer = %LevelTimer
@onready var level_duration_label: Label = %LevelDurationLabel

func _process(_delta: float) -> void:
	jarum.rotation_degrees = -(value / 100) * 360
	value = (timer.time_left / timer.wait_time) * 100
	
	var total_seconds := int(timer.time_left)

	var minutes := total_seconds / 60
	var seconds := total_seconds % 60

	level_duration_label.text = "%02d:%02d" % [minutes, seconds]
	
