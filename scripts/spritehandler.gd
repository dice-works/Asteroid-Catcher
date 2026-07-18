extends Node

func change_player_sprite_mouth(string):
	var player_sprite = get_node(
	"/root/Director/Spawner/Player/AnimatedSprite2D")
	player_sprite.play(string)
