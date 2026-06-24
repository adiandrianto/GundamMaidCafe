extends Node

@export var cooldown_timer: Timer
@export var progress_bar: ProgressBar

var skill_index: int
var cooldown_active: bool
var skill_active: bool

var tween := create_tween()

func _ready() -> void:
    progress_bar.min_value = 0.0
    progress_bar.max_value = 1.0

func _pressed() -> void:
    if cooldown_active or skill_active:
        return
    else:
        match skill_index:
            GlobalConstants.Skills.MULTIPLIER:
                # skill code
                pass
            GlobalConstants.Skills.MATCHING:
                # skill code
                pass
            GlobalConstants.Skills.PATIENCE:
                # skill code
                pass
        cooldown_timer.start
        cooldown_active = true
                


