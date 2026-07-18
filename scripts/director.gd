extends Node2D

var toggledFullscreen = false
var in_tutorial_mode = false

func _instantiate_background() -> void:
	var background_instance = preload("res://scenes/background.tscn").instantiate()
	get_parent().add_child.call_deferred(background_instance)

func _spawn_spawner() -> void:
	var spawner_instance = preload("res://scenes/spawner.tscn").instantiate()
	add_child(spawner_instance)

func _show_game_over_screen() -> void:
	var gameOver_instance = preload("res://scenes/game_over_screen.tscn").instantiate()
	add_child(gameOver_instance)
	get_tree().paused = true
	
func _exit_game() -> void:
	get_tree().quit()
	
func _setup_menu() -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()
	get_tree().paused = false
	var mainMenu_instance = preload("res://scenes/menu.tscn").instantiate()
	add_child(mainMenu_instance)
	
func _spawn_tutorial() -> void:
	var tutorial_instance = preload("res://scenes/tutorial.tscn").instantiate()
	add_child(tutorial_instance)

func _ready() -> void:
	Signalbus.round_started.connect(_spawn_spawner)
	Signalbus.round_ended.connect(_show_game_over_screen)
	Signalbus.tutorial_entered.connect(_spawn_tutorial)
	_instantiate_background()
	_setup_menu()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Fullscreen") && toggledFullscreen == false:
		toggledFullscreen = true
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN)
	elif Input.is_action_just_pressed("Fullscreen"):
		toggledFullscreen = false
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_WINDOWED)
