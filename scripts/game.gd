extends Node2D

var AppID = "480"
var player_scene = preload("res://scenes/player.tscn")
@onready var players = $Players

func _ready():
    create_singleplayer()
    
func create_singleplayer():
    var local_player = player_scene.instantiate()
    players.add_child(local_player)
    GameManager.set_player_color(local_player, GameManager.COLORS[GameManager.selected_color])
    GameManager.local_player = local_player 
