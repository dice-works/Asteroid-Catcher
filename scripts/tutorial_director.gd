extends Node2D

var Spawner:Node2D

func _show_mouse_help_tween() -> void:
	await get_tree().create_timer(1).timeout
	var _mouse_tween_visiblity_true = get_tree().create_tween().bind_node(self).tween_property(
		$sprite_mouse, "modulate:a", 1, 1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	var mouse_tween_movement = get_tree(
	).create_tween().bind_node(self).set_ease(
		Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE).set_loops(3)
	mouse_tween_movement.tween_property(
		$sprite_mouse, "position:y", 200, 1).as_relative()
	mouse_tween_movement.chain().tween_property(
		$sprite_mouse, "position:y", -200, 1).as_relative()
	await get_tree().create_timer(5).timeout #second to last loop of movement tween
	var _mouse_tween_visiblity_false = get_tree().create_tween().bind_node(self).tween_property(
		$sprite_mouse, "modulate:a", 0, 1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(2.5).timeout
	
func _catch_asteroid() -> void:
	$CatchText.visible = true
	Spawner._spawn_asteroid()

func _dodge_asteroid() -> void:
	$CatchText.visible = false
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
	await _show_mouse_help_tween()
	_catch_asteroid()
	Signalbus.tutorial_asteroid_missed.connect(_catch_asteroid)
	Signalbus.tutorial_asteroid_collected.connect(_dodge_asteroid)
	Signalbus.tutorial_badAsteroid_dodged.connect(_dodge_success)
	Signalbus.tutorial_hit_by_badAsteroid.connect(_dodge_failed)
