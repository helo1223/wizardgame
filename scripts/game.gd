extends Node2D

var AppID = "480"

# Called when the node enters the scene tree for the first time.
func _ready():
    #$Player.get_node("PlayerName").text = Globals.STEAM_NAME	
    set_color($Player, GameManager.COLORS[GameManager.selected_color])
    #set_color($Player2, COLORS[1])
    #set_color($Player3, COLORS[2])
    #set_color($Player4, COLORS[3])
    pass
    

func set_color(player, color):
    player.mageSprite.material.set_shader_parameter("target_color", color)
    player.cdBar.material.set_shader_parameter("target_color", color)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    var rand = randf_range(0,3)
    #set_color($Player, COLORS[rand])
    pass
