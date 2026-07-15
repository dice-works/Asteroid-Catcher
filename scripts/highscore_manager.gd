extends Node

var highscore

func _change_highscore(score) -> void:
	if score > highscore:
		highscore = score

func _check_save() -> void:
	if FileAccess.file_exists("user://highscore.dat"):
		var savefile = FileAccess.open("user://highscore.dat", FileAccess.READ)
		highscore = savefile.get_var()
	else:
		highscore = 0
	pass
	
func _save_highscore() -> void:
	var savefile = FileAccess.open("user://highscore.dat", FileAccess.WRITE)
	savefile.store_var(highscore)
	pass
	
func _reset_highscore() -> void:
	highscore = 0
	_save_highscore()

func _ready() -> void:
	_check_save()
	Signalbus.scored_point.connect(_change_highscore)
	Signalbus.game_over.connect(_save_highscore)
	Signalbus.reset_highscore.connect(_reset_highscore)
