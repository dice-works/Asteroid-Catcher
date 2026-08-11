extends Control

signal input_detected

var camera_moving:bool = false
@onready var camera:Camera2D = $Camera2D
@onready var camera_size = Vector2(
	camera.position.x * 2, camera.position.y * 2)
@onready var upper_area_target = Vector2(
	$SplashScreen/AreaMarker.global_position.x + ($SplashScreen/AreaMarker.size.x / 2), 
	$SplashScreen/AreaMarker.global_position.y + ($SplashScreen/AreaMarker.size.y / 2))
@onready var main_area_target = Vector2(
	$MainMenu/AreaMarker.global_position.x + ($MainMenu/AreaMarker.size.x / 2), 
	$MainMenu/AreaMarker.global_position.y + ($MainMenu/AreaMarker.size.y / 2))
@onready var options_area_target = Vector2(
	$OptionsMenu/AreaMarker.global_position.x + ($OptionsMenu/AreaMarker.size.x / 2), 
	$OptionsMenu/AreaMarker.global_position.y + ($OptionsMenu/AreaMarker.size.y / 2))

func _hide_editor_area_markers() -> void:
	$SplashScreen/AreaMarker.visible = false
	$MainMenu/AreaMarker.visible = false
	#$OptionsMenu/AreaMarker.visible = false
	pass
	
func _connect_button_signals() -> void:
	$MainMenu/PlayButton.pressed.connect(
		_move_camera.bind(upper_area_target, 1))
	$MainMenu/OptionsButton.pressed.connect(
		_move_camera.bind(options_area_target, 1))

func _move_camera(target:Vector2, duration:float) -> void:
	camera_moving = true
	var move_camera_tween = get_tree(
	).create_tween().bind_node(self).set_ease(
		Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	move_camera_tween.tween_property(
		camera, "position", target, duration)
	await move_camera_tween.finished
	camera_moving = false

func _animate_splash_screen() -> void:
	$SplashScreen/EnterLabel.visible = false
	var bounce_up_distance = upper_area_target - Vector2(0, 50)
	var logo:AnimatedSprite2D = $SplashScreen/Logo
	logo.play("cut")
	await _move_camera(bounce_up_distance, 0.6)
	await _move_camera(main_area_target, 1.8)
	
func _replace_splash_with_play() -> void:
	$SplashScreen.queue_free()
	var playmenu_instance = preload(
		"res://scenes/menu_play.tscn").instantiate()
	add_child(playmenu_instance)

func _print_stuff() -> void:
	print("worked")

func _input(event: InputEvent) -> void:
	if not event is InputEventMouse:
		input_detected.emit()
	if Input.is_action_just_pressed("Down"):
		_move_camera(main_area_target, 1)
	elif Input.is_action_just_pressed("Up"):
		_move_camera(upper_area_target, 1)
	elif Input.is_action_just_pressed("Left"):
		_move_camera(options_area_target, 1)
	elif Input.is_action_just_pressed("Right"):
		_move_camera(main_area_target, 1)

func _ready() -> void:
	_hide_editor_area_markers()
	Audiohandler._play_idle_music()
	await input_detected
	await _animate_splash_screen()
	_replace_splash_with_play()
	_connect_button_signals()
