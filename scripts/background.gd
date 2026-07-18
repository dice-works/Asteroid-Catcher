extends Node2D

@onready var far = $farStars
@onready var mid = $midStars
@onready var close = $closeStars

func _process(delta: float) -> void:
	far.scroll_offset.x -= (
		15 * Timerhandler.difficulty_scale_multiplier) * delta
	mid.scroll_offset.x -= (
		30 * Timerhandler.difficulty_scale_multiplier) * delta
	close.scroll_offset.x -= (
		50 * Timerhandler.difficulty_scale_multiplier) * delta
