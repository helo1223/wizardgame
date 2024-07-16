extends Node

var multiplayer_scene = preload("res://scenes/multiplayer/multiplayer_player.tscn")
var multiplayer_peer: SteamMultiplayerPeer = SteamMultiplayerPeer.new()
var _players_spawn_node
var _hosted_lobby_id = 0

const LOBBY_NAME = "helo's test"

func _ready():
    Steam.lobby_created.connect(_on_lobby_created.bind())
    
func become_host():
    multiplayer.peer_connected.connect(_add_player_to_game.bind())
    multiplayer.peer_disconnected.connect(_remove_player.bind())
    Steam.lobby_joined.connect(_on_lobby_joined.bind())
    Steam.createLobby(Steam.LOBBY_TYPE_PUBLIC, SteamManager.LOBBY_MAX_MEMBERS)
    
func join_game(lobby_id):
    Steam.lobby_joined.connect(_on_lobby_joined.bind())
    Steam.joinLobby(int(lobby_id))

func _on_lobby_created(_connect: int, lobby_id):
    if _connect == 1:
        _hosted_lobby_id = lobby_id
        Steam.setLobbyJoinable(_hosted_lobby_id, true)
        
        Steam.setLobbyData(_hosted_lobby_id, "name", LOBBY_NAME)
        Steam.setLobbyData(_hosted_lobby_id, "mode", "Co-op")
        Steam.allowP2PPacketRelay(true)

        _create_host()
        
func _create_host():
    var error = multiplayer_peer.create_host(0, [])
    if error == OK:
        multiplayer.set_multiplayer_peer(multiplayer_peer)
        
        _add_player_to_game(1)
    else:
        print("SteamNetwork: Error creating host: %s" % str(error))

func _on_lobby_joined(lobby_id: int, _permissions: int, _locked: bool, response: int):
    if response == 1:
        var id = Steam.getLobbyOwner(lobby_id)
        if id != Steam.getSteamID():
            connect_socket(id)
        else:
            pass
            
func connect_socket(steam_id : int):
    var error = multiplayer_peer.create_client(steam_id, 0, [])
    if error == OK:
        multiplayer.set_multiplayer_peer(multiplayer_peer)
    else:
        print("SteamNetwork: Error connecting to host: %s" % str(error))
        
func list_lobbies():
    Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_DEFAULT)
    Steam.addRequestLobbyListStringFilter("name", "", Steam.LOBBY_COMPARISON_NOT_EQUAL)
    Steam.requestLobbyList()

func _add_player_to_game(id: int):    
    var player_to_add = multiplayer_scene.instantiate()
    player_to_add.player_id = id
    player_to_add.name = str(id)
    
    _players_spawn_node.add_child(player_to_add, true)  

func _remove_player(id: int):
    if not _players_spawn_node.has_node(str(id)):
        return
    _players_spawn_node.get_node(str(id)).queue_free()
