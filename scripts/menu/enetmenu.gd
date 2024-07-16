extends Control

func _on_host_game_pressed():
    %MultiplayerManager.become_host()

func _on_join_game_pressed():
    %MultiplayerManager.join_game()

func _on_use_steam_pressed():
    %MultiplayerManager.use_steam()
