extends Control

func _on_singleplayer_pressed():
    $Home.visible = false
    $CharacterSelectPanel.visible = true

func _on_multiplayer_pressed():
    $Home.visible = false
    $MultiplayerPanel.visible = true
    SteamManager.initialize_steam()
    NetworkManager.active_network_type = NetworkManager.MULTIPLAYER_NETWORK_TYPE.STEAM
    NetworkManager.list_lobbies()
    
    
func _on_options_pressed():
    pass

func _on_exit_pressed():
    get_tree().quit()
