extends Node

var colorblindness_option_enabled = false
var music_option_enabled = true

func _toggle_color_blindness() -> void:
	colorblindness_option_enabled = !colorblindness_option_enabled

func _toggle_music() -> void:
	music_option_enabled = !music_option_enabled
	Audiohandler._toggle_music()
