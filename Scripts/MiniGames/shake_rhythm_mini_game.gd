extends MiniGame

const BPM: float = 105.0
const BEAT_INTERVAL: float = 60.0 / BPM
const PERFECT_WINDOW: float = 0.15 # 50 ms
const GOOD_WINDOW: float = 0.30    # 100 ms

@onready var tutorial: Label = %Tutorial
@onready var score_label: Label = %ScoreLabel
@onready var shaker: TextureButton = %Shaker
#@onready var audio: AudioStreamPlayer = %Beat
@onready var progress_bar: TextureProgressBar = %ProgressBar
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

static var show_tutorial: bool = true

var clicked: bool = false
var can_shake: bool = false
var center_pos: Vector2 = Vector2(400, 200)
var current_offset: Vector2 = Vector2.ZERO
var current_score: int = 0
var max_score: int = 16

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
		return
	
	countdown()

func _process(_delta: float) -> void:
	progress_bar.value = timer.time_left
	print(current_score)
	
func countdown():
	animation_player.play("count")
	await animation_player.animation_finished
	can_shake = true
	
	progress_bar.max_value = timer.wait_time
	timer.start()
	timer.timeout.connect(_on_timeout, CONNECT_ONE_SHOT)
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
		countdown()
	
	if not can_shake: 
		return
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

func _on_timeout():
	can_shake = false
	_evaluate_result()
	
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

#func _scoring():
	#show_tutorial = false
	#@warning_ignore("integer_division")
	#final_score = int(float(current_score) / float(max_score) * 10)
#
	#finished.emit(final_score)
	#await get_tree().create_timer(1.0).timeout
	#queue_free()

func _evaluate_result():
	set_process_input(false)
	
	final_score = int((float(current_score) / float(max_score)) * 10) 
	final_score = clampi(final_score, 1, 10)
	
	score_label.show()
	
	if final_score >= 9:
		animation_player.play("shake")
		score_label.text = "Perfect!"# + str(final_score)
		await get_tree().create_timer(0.2).timeout
		$Perfect.play()
	elif final_score >= 5:
		score_label.text = "Not Bad!"# + str(final_score)
		$Normal.play()
	else:
		score_label.text = "Slow Hands!"# + str(final_score)
		$Bad.play()
	
	await get_tree().create_timer(1.2).timeout

	finished.emit(final_score)
	show_tutorial = false
	animation_player.play("disappear")
