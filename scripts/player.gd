extends CharacterBody2D

@onready var trail:CPUParticles2D = $CPUParticles2D
@onready var sprite:AnimatedSprite2D = $AnimatedSprite2D
const speed = 2000
var score: int = 0

func _player_movement_logic() -> void:
	var mouse_target_y = get_global_mouse_position().y
	var viewport_border_y = get_viewport_rect().size.y
	var player_size = $WallCollider.shape.get_rect().size
	global_position.y = clamp(
		mouse_target_y, player_size.y/2, 
		viewport_border_y - (player_size.y/2))
	sprite.speed_scale = 1 * Timerhandler.difficulty_scale_multiplier
		
func _set_trail_to_current_frame() -> void:
	trail.texture = sprite.sprite_frames.get_frame_texture(
		sprite.animation, sprite.frame
	)
	
func _change_sprite(state:String) -> void:
	match state:
		"idle":
			sprite.play("idle")
		"ready":
			sprite.play("ready")
		"catch":
			sprite.play("catch")
		"hit":
			sprite.play("hit")

func _on_outerCollision_entered(area: Area2D) -> void:
	var asteroid = area.get_parent()
	if asteroid.is_in_group("Asteroid"):
		Signalbus.asteroid_in_players_reach.emit(asteroid)
		_change_sprite("ready")

func _on_innerCollision_entered(area: Area2D) -> void:
	var asteroid = area.get_parent()
	if asteroid.is_in_group("Asteroid") and asteroid.can_be_catched:
		_catch_asteroid(asteroid)
		_change_sprite("catch")
	
func _on_badCollision_entered(area: Area2D) -> void:
	var asteroid = area.get_parent()
	if asteroid.is_in_group("BadAsteroid"):
		Audiohandler._play_death_sound()
		Signalbus.return_asteroid_to_pool.emit(asteroid)
		if asteroid.is_in_group("Tutorial"):
			Signalbus.tutorial_hit_by_badAsteroid.emit()
		else:
			_change_sprite("hit")
			Signalbus.round_ended.emit()

func _catch_asteroid(asteroid) -> void:
	Audiohandler._play_eat_sound()
	Signalbus.return_asteroid_to_pool.emit(asteroid)
	Signalbus.player_caught_asteroid.emit()
	if asteroid.is_in_group("Tutorial"):
		Signalbus.tutorial_asteroid_collected.emit()

func _position_player_on_right_side() -> void:
	$Walls.top_level = true
	position.y = get_viewport_rect().size.y / 2
	position.x = get_viewport_rect().size.x - ($WallCollider.shape.get_rect().size.x / 2)
		
func _ready() -> void:
	sprite.play("idle")
	$OuterCollision.area_entered.connect(_on_outerCollision_entered)
	$InnerCollision.area_entered.connect(_on_innerCollision_entered)
	$BadCollision.area_entered.connect(_on_badCollision_entered)
	_position_player_on_right_side()
	
func _process(_delta: float) -> void:
	_player_movement_logic()
	_set_trail_to_current_frame()
