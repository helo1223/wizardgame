extends Control

func _on_host_p2p_game_pressed():
    %MultiplayerManager.become_host()
    
func _on_use_enet_pressed():
    %MultiplayerManager.use_enet()

func _on_list_lobbies_pressed():
    print("SteamMenu: Listing lobbies")
    %MultiplayerManager.list_lobbies()
