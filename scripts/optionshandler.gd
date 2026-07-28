extends Node

var music_option_enabled = true

func _toggle_music() -> void:
	music_option_enabled = !music_option_enabled
	Audiohandler._toggle_music()
