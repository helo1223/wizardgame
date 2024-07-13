extends Control

func _on_host_game_pressed():
    %GameManager.become_host()

func _on_join_game_pressed():
    %GameManager.join_game()

func _on_use_steam_pressed():
    %GameManager.use_steam()
