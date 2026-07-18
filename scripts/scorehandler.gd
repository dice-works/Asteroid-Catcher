extends Node

var score:int
var highscore:int

func _check_save() -> void:
	if FileAccess.file_exists("user://highscore.dat"):
		var savefile = FileAccess.open("user://highscore.dat", FileAccess.READ)
		highscore = savefile.get_var()
	else:
		highscore = 0

func _save_highscore() -> void:
	var savefile = FileAccess.open("user://highscore.dat", FileAccess.WRITE)
	savefile.store_var(highscore)

func _reset_highscore() -> void:
	highscore = 0
	_save_highscore()

func _reset_score() -> void:
	score = 0

func _handle_score() -> void:
	if not Director.in_tutorial_mode:
		score += 1
		if score > highscore:
			highscore = score

func _ready() -> void:
	_check_save()
	Signalbus.round_started.connect(_reset_score)
	Signalbus.player_caught_asteroid.connect(_handle_score)
	Signalbus.round_ended.connect(_save_highscore)
