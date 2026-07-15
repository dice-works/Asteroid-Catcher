extends Node

@onready var gamespace = get_node("/root/Main")

func change_player_sprite_mouth(string):
	if gamespace.has_node("Spawner"):
		var player_sprites:AnimatedSprite2D = (
			gamespace.get_node("Spawner/Player/AnimatedSprite2D"))
		player_sprites.play(string)
	else:
		var player_sprites:AnimatedSprite2D = (
			gamespace.get_node("Tutorial/Spawner/Player/AnimatedSprite2D"))
		player_sprites.play(string)		

func _ready() -> void:
	Signalbus.change_player_sprite_mouth.connect(change_player_sprite_mouth)
