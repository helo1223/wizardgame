class_name PlayerInput extends MultiplayerSynchronizer

@onready var player = $".."
var input_direction
var mouse_position
var username = ""

# Called when the node enters the scene tree for the first time.
func _ready():
    if not is_multiplayer_authority():
        return    
    input_direction = Input.get_vector("left", "right", "up", "down")
    
func _physics_process(delta):
    if not is_multiplayer_authority():
        return
        
    input_direction = Input.get_vector("left", "right", "up", "down")
    mouse_position = player.get_global_mouse_position()

    
func _process(delta):
    if not is_multiplayer_authority():
        return
    
    if Input.is_action_just_pressed("attack"):
        attack.rpc()

@rpc("call_local")
func attack():
    if player.canAttack:
        player.attacking = true

func set_color(color):
    player.mageSprite.material.set_shader_parameter("target_color", color)
    player.cdBar.material.set_shader_parameter("target_color", color)
