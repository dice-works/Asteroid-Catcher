extends Control

signal input_detected

@onready var camera:Camera2D = $Camera2D
@onready var camera_size:Vector2 = Vector2(
	camera.position.x * 2, camera.position.y * 2
)

func _hide_editor_area_markers() -> void:
	$SplashScreen/AreaMarker.visible = false
	$MainMenu/AreaMarker.visible = false
	$PlayMenu/AreaMarker.visible = false
	$OptionsMenu/AreaMarker.visible = false

func _move_camera(distance:float, dimension:String, duration:float) -> void:
	var move_camera_tween = get_tree(
	).create_tween().bind_node(self).set_ease(
		Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	if dimension == "y":
		move_camera_tween.tween_property(
			camera, "position:y", distance, duration).as_relative()
	elif dimension == "x":
		move_camera_tween.tween_property(
			camera, "position:x", distance, duration).as_relative()
	await move_camera_tween.finished

func _animate_splash_screen() -> void:
	$SplashScreen/EnterLabel.visible = false
	var bounce_up_distance = 50
	var logo:AnimatedSprite2D = $SplashScreen/Logo
	logo.play("cut")
	await _move_camera(-bounce_up_distance, "y", 0.6)
	_move_camera(bounce_up_distance + camera_size.y, "y", 1.8)

func _start_game() -> void:
	Audiohandler._play_select_sound()
	Signalbus.round_started.emit()
	queue_free()
		
func _exit_game() -> void:
	Director._exit_game()
	
func _enter_tutorial() -> void:
	Audiohandler._play_select_sound()
	Signalbus.tutorial_entered.emit()
	queue_free()

func _reset_highscore() -> void:
	Audiohandler._play_select_sound()
	Scorehandler._reset_highscore()
	_set_highscore_label()
	
func _set_highscore_label() -> void:
	$HighScoreText/Label.text = ("Highscore: " + str(Scorehandler.highscore))
	
func _toggle_music() -> void:
	Audiohandler._play_select_sound()
	Optionshandler._toggle_music()
	_set_music_button_color()

func _set_music_button_color() -> void:
	if Optionshandler.music_option_enabled:
		$MuteMusicToggle/ColorRect.color = Color.from_rgba8(84, 193, 125, 120)
	else:
		$MuteMusicToggle/ColorRect.color = Color.from_rgba8(130, 46, 36, 120)

func _input(event: InputEvent) -> void:
	if not event is InputEventMouse:
		input_detected.emit()

func _ready() -> void:
	_hide_editor_area_markers()
	Audiohandler._play_idle_music()
	await input_detected
	_animate_splash_screen()
