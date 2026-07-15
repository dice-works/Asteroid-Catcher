extends Node2D

var toggledFullscreen = false

func _show_menu() -> void:
	var mainMenuInstance = preload("res://scenes/menu.tscn").instantiate()
	add_child(mainMenuInstance)
	Signalbus.play_idle_music.emit()

func _spawn_spawner() -> void:
	var spawnerInstance = preload("res://scenes/spawner.tscn").instantiate()
	add_child(spawnerInstance)
	Signalbus.play_start_music.emit()

func _game_over() -> void:
	var gameOverInstance = preload("res://scenes/game_over_screen.tscn").instantiate()
	add_child(gameOverInstance)
	get_tree().paused = true
	
func _exit_game() -> void:
	get_tree().quit()
	
func _back_to_menu() -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()
	get_tree().paused = false
	_show_menu()
	
func _enter_tutorial() -> void:
	var tutorialInstance = preload("res://scenes/tutorial.tscn").instantiate()
	add_child(tutorialInstance)
	
func _ready() -> void:
	Signalbus.playbutton_pressed.connect(_spawn_spawner)
	Signalbus.game_over.connect(_game_over)
	Signalbus.exit_game.connect(_exit_game)
	Signalbus.back_to_menu.connect(_back_to_menu)
	Signalbus.enter_tutorial.connect(_enter_tutorial)
	_show_menu()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Fullscreen") && toggledFullscreen == false:
		toggledFullscreen = true
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN)
	elif Input.is_action_just_pressed("Fullscreen"):
		toggledFullscreen = false
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_WINDOWED)
