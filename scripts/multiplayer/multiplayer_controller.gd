extends CharacterBody2D


const SPEED = 100.0
const ATTACKSPEED = 1.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var player_id := 1:
    set(id):
        player_id = id
        %InputSynchronizer.set_multiplayer_authority(id)

@onready var mageSprite = $MageSprite
@onready var staffSprite = $MageSprite.get_node("StaffSprite")
@onready var cdBar = $Bar
@onready var attackTimer = $AttackTimer
@onready var playerNameLabel = $PlayerName
var username = ""

var attacking = false
var canAttack = true
var mouse_position = null

var inventory_visible = false
const COLORS = 	[Color(1.0, 0.0, 0.0, 1.0),
                Color(0.0, 1.0, 0.0, 1.0),
                Color(0.0, 0.0, 1.0, 1.0),
                Color(1.0, 1.0, 1.0, 1.0)]
                
func set_color(color):
    mageSprite.material.set_shader_parameter("target_color", color)
    cdBar.material.set_shader_parameter("target_color", color)
    
func _apply_animation(delta):
    handleMageAnimation()
    handleStaffAnimation()
    
func _apply_movement_from_input(delta):
    get_input()
    move_and_slide()

func _ready():
    if multiplayer.get_unique_id() == player_id:
        $Camera2D.make_current()
    else:
        $Camera2D.enabled = false
        
    $AttackTimer.wait_time = ATTACKSPEED
    cdBar.size = Vector2(0,40)
    set_color(randf_range(0,3))
    
func get_input():
    var input_direction = $InputSynchronizer.input_direction
    velocity = input_direction * SPEED
        
    if Input.is_action_just_pressed("inventory"):
        inventory_visible = !inventory_visible 
                

func handleMageAnimation():
    
    if velocity != Vector2.ZERO:
        mageSprite.animation =  "walk"
        if velocity.x < 0:
            mageSprite.speed_scale = -1
        else:
            mageSprite.speed_scale = 1
    else:
        mageSprite.animation =  "idle"
        mageSprite.speed_scale = 1
        
func handleStaffAnimation():
    if attacking && canAttack:
        staffSprite.speed_scale = 1
        staffSprite.play("attack")
        attackTimer.start()
        canAttack = false
    elif not attacking:
        var anim = "idle"
        if velocity != Vector2.ZERO:
                anim = "walk"
                if velocity.x < 0:
                    staffSprite.speed_scale = -1
                else:
                    staffSprite.speed_scale = 1
        else:
            anim =  "idle"
            staffSprite.speed_scale = 1
        staffSprite.play(anim)
            
    if not multiplayer.is_server() || MultiplayerManager.host_mode_enabled:
            handle_mouse_position()
    

    
func handle_mouse_position():
    #Flip sprites
    mouse_position = $InputSynchronizer.mouse_position
    if mouse_position:
        if mouse_position < position:
            mageSprite.flip_h = true
            if not attacking: staffSprite.speed_scale *= -1
            staffSprite.flip_v = true
        else:
            mageSprite.flip_h = false
            staffSprite.flip_v = false
            
        #Staff follows mouse
        staffSprite.look_at(mouse_position) 	

func handleCooldown():
    if attackTimer.time_left > 0.0:
        cdBar.visible = true
        cdBar.size = Vector2(40 - (attackTimer.time_left * 40),40)
    else:
        cdBar.visible = false
    
func _process(delta):
    handleCooldown()
    username = $InputSynchronizer.username
    $PlayerName.text = username
    set_color(COLORS[randf_range(0,3)])
    #displayInventory()
    
func _physics_process(delta):
    if multiplayer.is_server():
        _apply_movement_from_input(delta)
        
    if not multiplayer.is_server() || MultiplayerManager.host_mode_enabled:
        _apply_animation(delta)

func _on_attack_timer_timeout():
    attacking = false
    canAttack = true
