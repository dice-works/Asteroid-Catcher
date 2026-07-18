extends Node

var base_asteroid_spawn_time = 2
var min_asteroid_spawn_time = 0.4
var seconds_inside_round:float
var difficulty_scale_multiplier:float = 1.0
var difficulty_scale_rate = 0.05 #percent per second
var round_timer_on = false
	
func _reset_timer() -> void:
	seconds_inside_round = 0.0
	round_timer_on = false

func _start_timer_logic() -> void:
	$AsteroidTimer.wait_time = base_asteroid_spawn_time
	$BadAsteroidTimer.wait_time = base_asteroid_spawn_time * 2
	$AsteroidTimer.start()
	$BadAsteroidTimer.start()
	round_timer_on = true

func recalculate_asteroid_spawn_times() -> void:
	$AsteroidTimer.wait_time = max(
		base_asteroid_spawn_time / difficulty_scale_multiplier, min_asteroid_spawn_time)
	$BadAsteroidTimer.wait_time = max(
		(base_asteroid_spawn_time * 2) / difficulty_scale_multiplier, min_asteroid_spawn_time)

func _ready() -> void:
	Signalbus.round_started.connect(_start_timer_logic)
	Signalbus.round_ended.connect(_reset_timer)
	
func _process(delta: float) -> void:
	if round_timer_on:
		seconds_inside_round += delta
		difficulty_scale_multiplier = (
			1.0 + (seconds_inside_round * difficulty_scale_rate))
		recalculate_asteroid_spawn_times()
	if $AsteroidTimer.wait_time == min_asteroid_spawn_time:
		round_timer_on = false
