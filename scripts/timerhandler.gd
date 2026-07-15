extends Node

var base_asteroid_spawn_time = 2
var min_asteroid_spawn_time = 0.4
var seconds_inside_round:float
var difficulty_scale_multiplier:float
var difficulty_scale_rate = 0.05 #percent per second
var round_timer_on = false

func _start_round_timer() -> void:
	round_timer_on = true
	
func _reset_timer() -> void:
	seconds_inside_round = 0.0
	round_timer_on = false

func _set_start_time() -> void:
	$AsteroidTimer.wait_time = base_asteroid_spawn_time
	$BadAsteroidTimer.wait_time = base_asteroid_spawn_time * 2
	$AsteroidTimer.start()
	$BadAsteroidTimer.start()

func recalculate_asteroid_spawn_times() -> void:
	$AsteroidTimer.wait_time = max(
		base_asteroid_spawn_time / difficulty_scale_multiplier, min_asteroid_spawn_time)
	$BadAsteroidTimer.wait_time = max(
		(base_asteroid_spawn_time * 2) / difficulty_scale_multiplier, min_asteroid_spawn_time)

func _ready() -> void:
	Signalbus.start_spawn_timer.connect(_set_start_time)
	Signalbus.start_round_timer.connect(_start_round_timer)
	Signalbus.game_over.connect(_reset_timer)
	
func _process(delta: float) -> void:
	if round_timer_on:
		seconds_inside_round += delta
		difficulty_scale_multiplier = (
			1.0 + (seconds_inside_round * difficulty_scale_rate))
		recalculate_asteroid_spawn_times()
	else:
		difficulty_scale_multiplier = 1.0
