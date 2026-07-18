extends Control

func _exit_game() -> void:
	Director._exit_game()

func _back_to_menu() -> void:
	Audiohandler._play_select_sound()
	Director._setup_menu()

func _ready() -> void:
	$ExitButton/Button.pressed.connect(_exit_game)
	$MenuButton/Button.pressed.connect(_back_to_menu)
	$HighscoreText/Label.text = ("Highscore: " + str(Scorehandler.highscore))
