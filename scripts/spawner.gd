extends Node2D

const padding_x = 200
const padding_y = 28
var asteroidPool = []
var badAsteroidPool = []
var tutorial_mode_enabled:bool = false

func _remove_menu() -> void:
	if get_parent().get_node("Menu") != null:
		get_parent().get_node("Menu").queue_free()
		print("removed")
	else:
		print("menu not found")

func _instantiate_game() -> void:
	var player_instance = preload("res://scenes/Player.tscn").instantiate()
	add_child(player_instance)
	if not tutorial_mode_enabled:
		var scoreboard_instance = preload("res://scenes/scoreboard.tscn").instantiate()
		add_child(scoreboard_instance)
	
func _instantiate_asteroid_pool() -> void:
	for i in range(5):
		var asteroid = preload("res://scenes/asteroids.tscn").instantiate()
		asteroid.visible = false
		add_child(asteroid)
		asteroidPool.append(asteroid)
	for i in range(5):
		var badAsteroid = preload("res://scenes/badAsteroids.tscn").instantiate()
		badAsteroid.visible = false
		add_child(badAsteroid)
		badAsteroidPool.append(badAsteroid)

func _spawn_asteroid():
	for asteroid in asteroidPool.filter(func(a): return not a.visible):
		_set_asteroid_sprite(asteroid)
		var SpawnPosition = Vector2.ZERO
		SpawnPosition.x -= padding_x
		SpawnPosition.y = randi_range(padding_y, (int(get_viewport_rect().size.y) - padding_y))
		asteroid.position = SpawnPosition
		asteroid.visible = true
		asteroid.should_process = true
		asteroid.can_be_catched = false
		asteroid.speed = 200
		if tutorial_mode_enabled:
			asteroid.add_to_group("Tutorial")
		break

func _spawn_bad_asteroid():
	for badAsteroid in badAsteroidPool.filter(func(a): return not a.visible):
		_set_asteroid_sprite(badAsteroid)
		var SpawnPosition = Vector2.ZERO
		SpawnPosition.x -= padding_x
		SpawnPosition.y = randi_range(padding_y, (int(get_viewport_rect().size.y) - padding_y))
		badAsteroid.position = SpawnPosition
		badAsteroid.visible = true
		badAsteroid.should_process = true
		badAsteroid.speed = 200
		if tutorial_mode_enabled:
			badAsteroid.add_to_group("Tutorial")
		break

func _set_asteroid_sprite(asteroid:Node2D) -> void:
	var sprite:AnimatedSprite2D = asteroid.get_node("AnimatedSprite2D")
	var target_frame = randi_range(
		0, sprite.sprite_frames.get_frame_count(sprite.animation) - 1)
	sprite.stop()
	sprite.frame = target_frame
	print(target_frame, sprite.frame)

func _return_asteroid_to_pool(asteroid):
	asteroid.visible = false
	asteroid.should_process = false
	asteroid.position.y = get_viewport_rect().size.y * 2
	
func _setup_timer_signals():
	get_node("/root/Timerhandler/AsteroidTimer").timeout.connect(_spawn_asteroid)
	get_node("/root/Timerhandler/BadAsteroidTimer").timeout.connect(_spawn_bad_asteroid)
	
func _check_if_tutorial_mode():
	if Director.in_tutorial_mode:
		tutorial_mode_enabled = true
	else:
		_setup_timer_signals()
	
func _ready() -> void:
	_remove_menu()
	_instantiate_asteroid_pool()
	Signalbus.return_asteroid_to_pool.connect(_return_asteroid_to_pool)
	_check_if_tutorial_mode()
	_instantiate_game()
