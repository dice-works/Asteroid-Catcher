extends Control

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
	
func _toggle_color_blindness() -> void:
	Audiohandler._play_select_sound()
	Optionshandler._toggle_color_blindness()
	_set_color_blindness_button_color()

func _set_color_blindness_button_color() -> void:
	if Optionshandler.colorblindness_option_enabled:
		$ColorBlindnessToggle/ColorRect.color = Color.from_rgba8(84, 193, 125, 120)
	else:
		$ColorBlindnessToggle/ColorRect.color = Color.from_rgba8(130, 46, 36, 120)
		
func _toggle_music() -> void:
	Audiohandler._play_select_sound()
	Optionshandler._toggle_music()
	_set_music_button_color()

func _set_music_button_color() -> void:
	if Optionshandler.music_option_enabled:
		$MuteMusicToggle/ColorRect.color = Color.from_rgba8(84, 193, 125, 120)
	else:
		$MuteMusicToggle/ColorRect.color = Color.from_rgba8(130, 46, 36, 120)
	
func _ready() -> void:
	Audiohandler._play_idle_music()
	$PlayButton/Button.pressed.connect(_start_game)
	$ExitButton/Button.pressed.connect(_exit_game)
	$ResetHighscore/Button.pressed.connect(_reset_highscore)
	$TutorialButton/Button.pressed.connect(_enter_tutorial)
	$ColorBlindnessToggle/Button.pressed.connect(_toggle_color_blindness)
	$MuteMusicToggle/Button.pressed.connect(_toggle_music)
	_set_highscore_label()
	_set_color_blindness_button_color()
	_set_music_button_color()
