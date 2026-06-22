extends MiniGame

@onready var score: Node2D = $Score

func scoring():
	final_score = score.total_score / 10

	finished.emit(final_score)
	await get_tree().create_timer(1.0).timeout
	queue_free()
