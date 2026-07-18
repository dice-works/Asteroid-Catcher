extends Node

var sound_randomizer_token = 0

func _play_eat_sound() -> void:
	match sound_randomizer_token:
		0:
			$Eat1.play()
		1:
			$Eat2.play()
		2:
			$Eat3.play()
	sound_randomizer_token = randi_range(0, 2)
	
func _play_death_sound() -> void:
	$Death.play()
	
func _play_select_sound() -> void:
	$Select.play()
	
func _play_idle_music() -> void:
	$Asteroid_Start.stop()
	$Asteroid_Loop.stop()
	if not $Asteroid_Idle.playing and Optionshandler.music_option_enabled:
		$Asteroid_Idle.play()
	
func _play_start_music() -> void:
	$Asteroid_Idle.stop()
	if Optionshandler.music_option_enabled:
		$Asteroid_Start.play()
	
func _play_main_music() -> void:
	if Optionshandler.music_option_enabled:
		$Asteroid_Loop.play()
	
func _toggle_music() -> void:
	if $Asteroid_Idle.playing:
		$Asteroid_Idle.stop()
	else:
		$Asteroid_Idle.play()

func _ready() -> void:
	Signalbus.round_started.connect(_play_start_music)
	Signalbus.round_ended.connect(_play_idle_music)
	$Asteroid_Start.finished.connect(_play_main_music)
