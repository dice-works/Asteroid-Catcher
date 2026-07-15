extends CharacterBody2D

#@onready var trail = $CPUParticles2D
const speed = 2000
var score: int = 0
@export var test: Curve

func _player_movement_logic() -> void:
	var mouse_target_y = get_global_mouse_position().y
	var viewport_border_y = get_viewport_rect().size.y
	var player_size = $WallCollider.shape.get_rect().size
	global_position.y = clamp(
		mouse_target_y, player_size.y/2, 
		viewport_border_y - (player_size.y/2))	

func _on_outerCollision_entered(area: Area2D) -> void:
	var asteroid = area.get_parent()
	if not asteroid.is_in_group("BadAsteroids"):
		Signalbus._asteroid_in_player_outer_collision(asteroid)

func _on_innerCollision_entered(area: Area2D) -> void:
	var asteroid = area.get_parent()
	Signalbus.check_trigger.emit(asteroid)
	
func _on_badCollision_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("BadAsteroids"):
		Signalbus.play_death_sound.emit()
		Signalbus.return_asteroid_to_pool.emit(area.get_parent())
		if not area.get_parent().is_in_group("Tutorial"):
			Signalbus.game_over.emit()

func _eat_asteroid(asteroid) -> void:
	Signalbus.play_eat_sound.emit()
	Signalbus.change_player_sprite_mouth.emit("closed")
	score += 1
	Signalbus.return_asteroid_to_pool.emit(asteroid)
	if not asteroid.is_in_group("Tutorial"):
		Signalbus.scored_point.emit(score)
	else:
		Signalbus.tutorial_asteroid_collected.emit()
		
func _ready() -> void:
	$OuterCollision.area_entered.connect(_on_outerCollision_entered)
	$InnerCollision.area_entered.connect(_on_innerCollision_entered)
	$BadCollision.area_entered.connect(_on_badCollision_entered)
	Signalbus.eat_asteroid.connect(_eat_asteroid)
	
	$Walls.top_level = true
	position.y = get_viewport_rect().size.y / 2
	position.x = get_viewport_rect().size.x - ($WallCollider.shape.get_rect().size.x / 2)
	
func _process(_delta: float) -> void:
	_player_movement_logic()
