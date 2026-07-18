extends Node2D

var Spawner:Node2D

func _show_move_keys() -> void:
	$UpIcon.visible = true
	$DownIcon.visible = true
	$FullscreenIcon.visible = true
	await get_tree().create_timer(4.5).timeout
	$UpIcon.visible = false
	$DownIcon.visible = false
	$FullscreenIcon.visible = false
	
func _collect_asteroid() -> void:
	$CollectText.visible = true
	Spawner._spawn_asteroid()

func _dodge_asteroid() -> void:
	$CollectText.visible = false
	await get_tree().create_timer(1).timeout
	$DodgeText.visible = true
	Spawner._spawn_bad_asteroid()
	
func _dodge_failed() -> void:
	$DodgeFailOverlay.visible = true
	get_tree().paused = true
	await get_tree().create_timer(1).timeout
	get_tree().paused = false
	$DodgeFailOverlay.visible = false
	_dodge_asteroid()
	
func _dodge_success() -> void:
	$DodgeText.visible = false
	$GoodJobText.visible = true
	$ReturningtoMenuText.visible = true
	await get_tree().create_timer(3).timeout
	Director.in_tutorial_mode = false
	Director._setup_menu()
	
func _ready() -> void:
	Director.in_tutorial_mode = true
	Director._spawn_spawner()
	Spawner = get_node("/root/Director/Spawner")
	await _show_move_keys()
	_collect_asteroid()
	Signalbus.tutorial_asteroid_missed.connect(_collect_asteroid)
	Signalbus.tutorial_asteroid_collected.connect(_dodge_asteroid)
	Signalbus.tutorial_badAsteroid_dodged.connect(_dodge_success)
	Signalbus.tutorial_hit_by_badAsteroid.connect(_dodge_failed)
