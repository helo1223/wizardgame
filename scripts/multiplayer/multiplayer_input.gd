extends MultiplayerSynchronizer

@onready var player = $".."
var input_direction
var mouse_position
var username = ""

# Called when the node enters the scene tree for the first time.
func _ready():
    if get_multiplayer_authority() != multiplayer.get_unique_id():
        set_process(false)
        set_physics_process(false)
    
    input_direction = Input.get_vector("left", "right", "up", "down")
    mouse_position = player.get_global_mouse_position()
    username = SteamManager.STEAM_NAME
    
func _physics_process(delta):
    input_direction = Input.get_vector("left", "right", "up", "down")
    mouse_position = player.get_global_mouse_position()
    
func _process(delta):
    if Input.is_action_just_pressed("attack"):
        attack.rpc()

@rpc("call_local")
func attack():
    if multiplayer.is_server():
        player.attacking = true
    
