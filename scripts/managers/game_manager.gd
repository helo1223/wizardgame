extends Node

const COLORS = 	[Color(1.0, 0.21, 0.16, 1.0),
                Color(0.0, 0.67, 0.0, 1.0),
                Color(0.19, 0.42, 1.0, 1.0),
                Color(0.73, 0.0, 1.0, 1.0)]

var selected_color : int = 0
var local_player = null

func set_color(sprite : Node, color : Color):
    sprite.material.set_shader_parameter("target_color", color)
    
func set_player_color(player : CharacterBody2D, color : Color):
    set_color(player.mageSprite, color)
