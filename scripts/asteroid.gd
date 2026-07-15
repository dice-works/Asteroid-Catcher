extends Node2D

@onready var asteroid_bounds_threshold = (
$Area2D/CollisionShape2D.shape.get_rect().size.x)
var speed:int
var can_be_catched = false
var should_process = false

func _check_color_blindness() -> void:
	if Optionshandler.colorblindness_option_enabled:
		$Sprite2D.texture = preload("res://textures_and_audios/asteroid_blindness.png")
	else:
		$Sprite2D.texture = preload("res://textures_and_audios/asteroid.png")

func _ChangeMouthTrigger(asteroid: Node2D) -> void:
	if asteroid == self && can_be_catched == false:
			can_be_catched = true
	
func _CheckMouthTrigger(asteroid: Node2D) -> void:
	if asteroid == self && can_be_catched == true:
		Signalbus.eat_asteroid.emit(self)
	
	
func _ready() -> void:
	Signalbus.trigger_mouth.connect(_ChangeMouthTrigger)
	Signalbus.check_trigger.connect(_CheckMouthTrigger)
	_check_color_blindness()

func _process(delta: float) -> void:
	if should_process:
		position.x += (speed * Timerhandler.difficulty_scale_multiplier) * delta
		if position.x > (get_viewport_rect().size.x + asteroid_bounds_threshold):
			if is_in_group("Tutorial"):
				Signalbus.tutorial_asteroid_missed.emit()
			Signalbus.return_asteroid_to_pool.emit(self)
