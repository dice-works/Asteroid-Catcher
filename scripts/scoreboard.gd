extends CanvasLayer


func change_score() -> void:
	$Label.text = "Score: " + str(Scorehandler.score)

func _ready() -> void:
	Signalbus.player_caught_asteroid.connect(change_score)
