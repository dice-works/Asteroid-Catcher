extends Control

signal input_detected

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
	Audiohandler._play_idle_music()
	await input_detected
	print("go")
