extends MiniGame

const BPM: float = 105.0
const BEAT_INTERVAL: float = 60.0 / BPM
const PERFECT_WINDOW: float = 0.15 # 50 ms
const GOOD_WINDOW: float = 0.30    # 100 ms

@onready var tutorial: Label = %Tutorial
@onready var score_label: Label = %ScoreLabel
@onready var shaker: TextureButton = %Shaker
#@onready var audio: AudioStreamPlayer = %Beat
@onready var beat_bar: TextureProgressBar = %BeatBar

static var show_tutorial: bool = true

var clicked: bool = false
var center_pos: Vector2 = Vector2(400, 200)
var current_offset: Vector2 = Vector2.ZERO
var current_score: int = 0
var max_score: int = 20

#var loop_duration := BEAT_INTERVAL * 4 #detik
#var beat_to_click: Array[int] = [3, 4, 7, 8, 11, 12, 15, 16]
#var current_beat: int = 1
#var note_index := 0
#var last_judged_note := -1

# hrs score dari 8 kali klik
# perfect dapat 3, good dapat 2, missed ga dapat
# max score 8 * 3 = 24 -> rentang score terakhir 1-10
#var current_score: int = 0
#var max_score: int = 23

func _ready() -> void:
	super._ready()
	#audio.finished.connect(_scoring)
	shaker.pressed.connect(_on_shaker_pressed)
	center_pos = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width")/2, ProjectSettings.get_setting("display/window/size/viewport_height")/2 - 180) #- Vector2(shaker.size.x/2, -shaker.size.y/2)
	tutorial.hide()
	score_label.hide()
	
	if show_tutorial:
		tutorial.show()
#func _process(_delta: float) -> void:
	#current_beat = floori(_get_current_beat_float())
	#
	#if note_index < beat_to_click.size():
		#var target_beat = beat_to_click[note_index]
		#if _get_current_beat_float() > target_beat + GOOD_WINDOW:
			#score_label.text = "MISSED"
			#note_index += 1
			#
	#var pos = audio.get_playback_position() + AudioServer.get_time_since_last_mix()
	#var loop_pos = fmod(pos, loop_duration)
	#beat_bar.value = (loop_pos / loop_duration)

func _on_shaker_pressed() -> void:
	if not clicked:
		clicked = true
		tutorial.hide()
	#_judge_note()
	_shake_shaker()
	current_score += 1

func _shake_shaker():
	var target_pos = center_pos + Vector2(randf_range(-200, 200), randf_range(-120, 120))
	var target_rot = randf_range(-30, 30)
	var tween = create_tween()

	tween.set_parallel(true)
	tween.tween_property(shaker, "position", target_pos, 0.05)
	tween.tween_property(shaker, "rotation_degrees", target_rot, 0.05)
	tween.chain().tween_property(shaker, "position", center_pos, 0.05)
	
#func _get_current_beat_float() -> float:
	#var song_time = audio.get_playback_position() + AudioServer.get_time_since_last_mix()
	#return (song_time / BEAT_INTERVAL) + 1

#func _judge_note():
	#if note_index >= beat_to_click.size():
		#return
#
	#if last_judged_note == note_index:
		#return
		#
	#var current_beat_float = _get_current_beat_float()
	#var target_beat = float(beat_to_click[note_index])
	#var diff = abs(current_beat_float - target_beat)
#
	#if diff <= PERFECT_WINDOW:
		#score_label.text = "PERFECT"
		#current_score += 3
		#last_judged_note = note_index
		#note_index += 1
	#elif diff <= GOOD_WINDOW:
		#score_label.text = "GOOD"
		#current_score += 2
		#last_judged_note = note_index
		#note_index += 1
	#else :
		#score_label.text = "BAD"
	#
	#print("current score " + str(current_score))

func _scoring():
	show_tutorial = false
	@warning_ignore("integer_division")
	final_score = int(float(current_score) / float(max_score) * 10)

	finished.emit(final_score)
	await get_tree().create_timer(1.0).timeout
	queue_free()
