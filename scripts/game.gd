extends Node2D

var AppID = "480"

func _ready():
    GameManager.set_player_color($Player, GameManager.COLORS[GameManager.selected_color])
