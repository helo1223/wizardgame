extends Panel

func _ready():
    Steam.lobby_match_list.connect(_on_lobby_match_list)

func _on_multi_back_pressed():
    $"../Home".visible = true
    $".".visible = false

func _on_lobby_match_list(lobbies: Array):
    for lobby_child in $Lobbies.get_children():
        lobby_child.queue_free()
    
    $Label2.text = "(%s)" % lobbies.size()
    for lobby in lobbies:
        var lobby_name: String = Steam.getLobbyData(lobby, "name")
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

            var vbox = $Lobbies
            vbox.add_child(lobby_button)
            
func join_lobby(lobby_id = 0):
    NetworkManager.join_game(lobby_id)
