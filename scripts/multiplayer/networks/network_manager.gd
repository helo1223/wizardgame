extends Node

enum MULTIPLAYER_NETWORK_TYPE { ENET, STEAM }

@export var _players_spawn_node: Node2D

var active_network_type: MULTIPLAYER_NETWORK_TYPE = MULTIPLAYER_NETWORK_TYPE.ENET
var enet_network_scene := preload("res://scenes/multiplayer/network/enet_network.tscn")
var steam_network_scene := preload("res://scenes/multiplayer/network/steam_network.tscn")
var active_network

func _build_multiplayer_network():
    if not active_network:
        print("Setting active_network")
        MultiplayerManager.multiplayer_mode_enabled = true

        match active_network_type:
            MULTIPLAYER_NETWORK_TYPE.ENET:
                print("Setting ENET network type")
                _set_active_network(enet_network_scene)
            MULTIPLAYER_NETWORK_TYPE.STEAM:
                print("Setting Steam network type")
                _set_active_network(steam_network_scene)
            _:
                print("No matching network type")

func _set_active_network(active_network_scene):
    var network_scene_initialized = active_network_scene.instantiate()
    active_network = network_scene_initialized
    active_network._players_spawn_node = _players_spawn_node
    add_child(active_network)

func become_host():
    _build_multiplayer_network()
    MultiplayerManager.host_mode_enabled = true
    active_network.become_host()
        
func join_game(lobby_id = 0):
    _build_multiplayer_network()
    active_network.join_game(lobby_id)
    
func list_lobbies():
    _build_multiplayer_network()
    active_network.list_lobbies()
