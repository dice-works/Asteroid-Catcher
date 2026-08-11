extends Node

func _emit_start_signal() -> void:
	Signalbus.round_started.emit()

func _emit_tutorial_signal() -> void:
	Signalbus.tutorial_entered.emit()

func _ready() -> void:
	$StartButton.pressed.connect(_emit_start_signal)
