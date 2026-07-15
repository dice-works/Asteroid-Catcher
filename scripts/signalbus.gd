extends Node
@warning_ignore_start("unused_signal")

# Asteroid Logic
signal trigger_mouth(asteroid)
signal check_trigger(asteroid)
signal eat_asteroid(asteroid)
signal return_asteroid_to_pool(asteroid)
signal game_over()
signal scored_point(newScore: int)

# Menu Logic
signal playbutton_pressed()
signal reset_highscore()
signal exit_game()
signal back_to_menu()
signal toggle_color_blindness_option()
signal toggle_music_option()

# Audio
signal play_eat_sound()
signal play_death_sound()
signal play_select_sound()
signal play_idle_music()
signal play_start_music()

# Sprites
signal change_player_sprite_mouth(state: String)

# Tutorial
signal enter_tutorial()
signal tutorial_asteroid_collected()
signal tutorial_asteroid_missed()
signal tutorial_badAsteroid_dodged()

# Misc
signal start_spawn_timer()
signal start_round_timer()

# functions
func _asteroid_in_player_outer_collision(asteroid):
	change_player_sprite_mouth.emit("open")
	trigger_mouth.emit(asteroid)
