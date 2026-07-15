extends Node2D

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
	get_node("Spawner")._spawn_asteroid()

func _dodge_asteroid() -> void:
	$CollectText.visible = false
	await get_tree().create_timer(1).timeout
	$DodgeText.visible = true
	get_node("Spawner")._spawn_bad_asteroid()
	
func _dodge_failed() -> void:
	$DodgeFailOverlay.visible = true
	Audiohandler._play_death_sound()
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
	Signalbus.back_to_menu.emit()
	
func _ready() -> void:
	var spawnerInstance = preload("res://scenes/spawner.tscn").instantiate()
	add_child(spawnerInstance)
	await _show_move_keys()
	_collect_asteroid()
	Signalbus.tutorial_asteroid_missed.connect(_collect_asteroid)
	Signalbus.tutorial_asteroid_collected.connect(_dodge_asteroid)
	Signalbus.tutorial_badAsteroid_dodged.connect(_dodge_success)
	Signalbus.play_death_sound.connect(_dodge_failed)
