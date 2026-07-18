extends Node
@warning_ignore_start("unused_signal")

# Asteroid Logic
signal return_asteroid_to_pool(asteroid)

# Tutorial
signal tutorial_entered()
signal tutorial_asteroid_collected()
signal tutorial_asteroid_missed()
signal tutorial_badAsteroid_dodged()
signal tutorial_hit_by_badAsteroid()

# New broad signals
signal round_started()
signal round_ended()
signal menu_instantiated()
signal asteroid_in_players_reach(asteroid)
signal player_caught_asteroid()
