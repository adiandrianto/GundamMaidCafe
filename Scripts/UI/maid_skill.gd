extends Node

@export var cooldown_timer: Timer
@export var skill_timer: Timer
@export var progress_bar: ProgressBar

@export var skill_index: GlobalConstants.Skills
var cooldown_active: bool
var skill_active: bool


func _ready() -> void:
    progress_bar.min_value = 0.0
    progress_bar.max_value = 1.0
    progress_bar.value = 1.0
    cooldown_timer.timeout.connect(_on_cooldown_timeout)
    skill_timer.timeout.connect(end_skill_timer)
    progress_bar.hide()

func _process(delta: float) -> void:
    if cooldown_active and cooldown_timer and cooldown_timer.wait_time > 0:
        var progress = 1.0 - (cooldown_timer.time_left / cooldown_timer.wait_time)
        progress_bar.value = progress

func _pressed() -> void:
    if cooldown_active or skill_active:
        return
    else:
        match skill_index:
            GlobalConstants.Skills.MULTIPLIER:
                var mult: int = 2 #temporary
                start_skill_timer()
                GameManager.modify_multiplier(mult)
            GlobalConstants.Skills.MATCHING:
                start_skill_timer()
                GameManager.modify_personality(GlobalConstants.Personality.ULTIMATE)
            GlobalConstants.Skills.PATIENCE:
                print("patience skill")
                start_skill_timer()
                GameManager.patience_reset()

func start_skill_timer() -> void:
    skill_timer.start()
    skill_active = true

func end_skill_timer() -> void:
    skill_active = false
    GameManager.modify_multiplier(1)
    progress_bar.value = 0.0
    progress_bar.show()
    cooldown_timer.start()
    cooldown_active = true

func _on_cooldown_timeout() -> void:
    cooldown_active = false
    progress_bar.value = 1.0
    progress_bar.hide()