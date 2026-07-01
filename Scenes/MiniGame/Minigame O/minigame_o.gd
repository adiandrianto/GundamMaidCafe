extends MiniGame

@onready var score: Node2D = %Score
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var tutorial: Label = %Tutorial
@onready var score_label: Label = %ScoreLabel

static var show_tutorial: bool = true

func _ready() -> void:
	super._ready()
	tutorial.hide()
	score_label.hide()
	animation_player.play("appear")
	%Objects.all_object_moved.connect(_evaluate_score)

	if show_tutorial:
		tutorial.show()

func _evaluate_score() -> void:
	tutorial.hide()
	set_process_input(false)
	
	final_score = score.get_score() / 10
	score_label.show()

	if final_score >= 9:
		animation_player.play("shake")
		score_label.text = "Perfect!"# + str(final_score)
		await get_tree().create_timer(0.2).timeout
		$Perfect.play()
	elif final_score >= 5 && final_score < 9:
		score_label.text = "Not Bad!"# + str(final_score)
		$Good.play()
	else: 
		score_label.text = "Poor!"# + str(final_score)
		$Bad.play()

	await get_tree().create_timer(1.2).timeout

	finished.emit(final_score)
	Scores.omelette += final_score
	show_tutorial = false
	animation_player.play("disappear")
