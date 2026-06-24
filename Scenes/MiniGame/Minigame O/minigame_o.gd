extends MiniGame

@onready var score: Node2D = $Score
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var tutorial: Label = $Panel/Tutorial

static var show_tutorial: bool = true

func _ready() -> void:
	super._ready()
	tutorial.hide()
	animation_player.play("appear")

	if show_tutorial:
		tutorial.show()

func scoring():
	final_score = score.get_score() / 10

	finished.emit(final_score)
	await get_tree().create_timer(1.0).timeout
	queue_free()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		print("input")
