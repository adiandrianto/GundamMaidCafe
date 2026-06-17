extends Control

const BPM = 105.0
const BEAT_INTERVAL = 60.0 / BPM

var center_pos := Vector2(400, 200)
var current_offset = Vector2.ZERO

@onready var score_label: Label = %ScoreLabel
@onready var shaker: TextureButton = %Shaker
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer
@onready var beat_bar: TextureProgressBar = %BeatBar

var loop_duration := BEAT_INTERVAL * 4 #detik

func _ready() -> void:
	shaker.pressed.connect(_on_shaker_pressed)
	center_pos = shaker.global_position #- Vector2(shaker.size.x/2, -shaker.size.y/2)
	
func _draw() -> void:
	draw_circle(center_pos, 16, Color.ALICE_BLUE)
	
func _process(_delta: float) -> void:
	var pos = audio.get_playback_position() + AudioServer.get_time_since_last_mix()
	var loop_pos = fmod(pos, loop_duration)
	beat_bar.value = (loop_pos / loop_duration)

func _on_shaker_pressed() -> void:
	var target_pos = center_pos + Vector2(randf_range(-200, 200), randf_range(-120, 120))
	var target_rot = randf_range(-30, 30)
	var tween = create_tween()

	tween.set_parallel(true)
	tween.tween_property(shaker, "position", target_pos, 0.05)
	tween.tween_property(shaker, "rotation_degrees", target_rot, 0.05)
	tween.chain().tween_property(shaker, "position", center_pos, 0.05)
