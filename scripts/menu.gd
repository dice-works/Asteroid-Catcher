extends Control

func _start_game() -> void:
		Signalbus.play_select_sound.emit()
		var background = get_node("Background")
		background.queue_free()
		Signalbus.playbutton_pressed.emit()
		queue_free()
		
func _exit_game() -> void:
	Signalbus.exit_game.emit()
	
func _enter_tutorial() -> void:
	Signalbus.play_select_sound.emit()
	Signalbus.enter_tutorial.emit()
	queue_free()

func _reset_highscore() -> void:
	Signalbus.play_select_sound.emit()
	Signalbus.reset_highscore.emit()
	_change_highscore_label()
	
func _change_highscore_label() -> void:
	$HighScoreText/Label.text = ("Highscore: " + str(HighscoreManager.highscore))
	
func _toggle_color_blindness() -> void:
	Signalbus.play_select_sound.emit()
	Signalbus.toggle_color_blindness_option.emit()
	_set_color_blindness_button()

func _set_color_blindness_button() -> void:
	if Optionshandler.colorblindness_option_enabled:
		$ColorBlindnessToggle/ColorRect.color = Color.from_rgba8(84, 193, 125, 120)
	else:
		$ColorBlindnessToggle/ColorRect.color = Color.from_rgba8(130, 46, 36, 120)
		
func _music_toggle_button_pressed() -> void:
	Signalbus.play_select_sound.emit()
	Signalbus.toggle_music_option.emit()
	_set_music_button_color()

func _set_music_button_color() -> void:
	if Optionshandler.music_option_enabled:
		$MuteMusicToggle/ColorRect.color = Color.from_rgba8(84, 193, 125, 120)
	else:
		$MuteMusicToggle/ColorRect.color = Color.from_rgba8(130, 46, 36, 120)
	
func _ready() -> void:
	var backgroundInstance = preload("res://scenes/background.tscn").instantiate()
	add_child(backgroundInstance)
	$PlayButton/Button.pressed.connect(_start_game)
	$ExitButton/Button.pressed.connect(_exit_game)
	$ResetHighscore/Button.pressed.connect(_reset_highscore)
	$TutorialButton/Button.pressed.connect(_enter_tutorial)
	$ColorBlindnessToggle/Button.pressed.connect(_toggle_color_blindness)
	$MuteMusicToggle/Button.pressed.connect(_music_toggle_button_pressed)
	_change_highscore_label()
	_set_color_blindness_button()
	_set_music_button_color()
