extends Control

func _on_host_p2p_game_pressed():
    %GameManager.become_host()
    
func _on_use_enet_pressed():
    %GameManager.use_enet()

func _on_list_lobbies_pressed():
    print("SteamMenu: Listing lobbies")
    %GameManager.list_lobbies()
