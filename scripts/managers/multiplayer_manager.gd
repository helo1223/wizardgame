extends Node

var host_mode_enabled = false
var multiplayer_mode_enabled = false

func become_host():
    print("Host button pressed")
    _remove_single_player()
    %MultiplayerHUD.hide()
    %SteamHUD.hide()
    %NetworkManager.become_host()
        
func join_game():
    print("Join button pressed")
    join_lobby()

func join_lobby(lobby_id = 0):
    _remove_single_player()
    %MultiplayerHUD.hide()
    %SteamHUD.hide()
    %NetworkManager.join_game(lobby_id)

func _on_lobby_match_list(lobbies: Array):
    print("GameManager: lobby match list")
    for lobby_child in $"../SteamHUD/Panel/Lobbies/VBoxContainer".get_children():
        lobby_child.queue_free()
    
    print("Found %s lobbies" % lobbies.size())
    for lobby in lobbies:
        var lobby_name: String = Steam.getLobbyData(lobby, "name")
        print("Lobby: %s" % lobby_name)
        if lobby_name != "":
            var lobby_mode: String = Steam.getLobbyData(lobby, "mode")
            var lobby_button: Button = Button.new()
            lobby_button.set_text(lobby_name + " | " + lobby_mode)
            lobby_button.set_size(Vector2(100,30))
            lobby_button.add_theme_font_size_override("font_size", 8)
            
            var fv = FontVariation.new()
            fv.set_base_font(load("res://assets/fonts/PixelOperator8.ttf"))
            lobby_button.add_theme_font_override("font", fv)
            lobby_button.set_name("lobby_%s" % lobby)
            lobby_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
            lobby_button.connect("pressed", Callable(self, "join_lobby").bind(lobby))

            var vbox = $"../SteamHUD/Panel/Lobbies/VBoxContainer"
            print(vbox)
            vbox.add_child(lobby_button)

func use_enet():
    print("Using ENet")
    %MultiplayerHUD.show()
    %SteamHUD.hide()
    %NetworkManager.active_network_type = %NetworkManager.MULTIPLAYER_NETWORK_TYPE.ENET
    
func use_steam():
    print("Using Steam")
    $MainMenu.hide()
    %SteamHUD.show()
    SteamManager.initialize_steam()
    %NetworkManager.active_network_type = %NetworkManager.MULTIPLAYER_NETWORK_TYPE.STEAM
    Steam.lobby_match_list.connect(_on_lobby_match_list)
    
func list_lobbies():
    print("Listing lobbies")
    %NetworkManager.list_lobbies()
    
func _remove_single_player():
    print("Removing single player")
    var player_to_remove = get_tree().get_current_scene().get_node("Player")
    if player_to_remove:
        player_to_remove.queue_free()
