extends CharacterBody2D


const SPEED = 100.0
const ATTACKSPEED = 1.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var bullet_scene = preload("res://scenes/bullet.tscn")

@export var player_input: PlayerInput

@export var player_id := 1:
    set(id):
        player_id = id
        #player_input.set_multiplayer_authority(id)

@onready var mageSprite = $Mage
@onready var staffSprite = $Mage/Staff
@onready var cdBar = $Bar
@onready var attack_timer = $AttackTimer
@onready var playerNameLabel = $PlayerName
@onready var bullets = %Bullets
@onready var marker = $Marker2D

var username = ""
var attack_time = 0.0

var attacking = false
var canAttack = true
var mouse_position = null

var inventory_visible = false
                
var player_color = GameManager.COLORS[0]
                
func set_color(color):
    mageSprite.material.set_shader_parameter("target_color", color)
    cdBar.material.set_shader_parameter("target_color", color)
    
func _apply_animation(_delta):
    handleMageAnimation()
    handleStaffAnimation()
    
func _apply_movement_from_input(_delta):
    get_input()
    move_and_slide()

func _ready():
    await get_tree().process_frame
    $".".set_multiplayer_authority(str(name).to_int())
    if multiplayer.get_unique_id() == player_id:
        $Camera2D.make_current()
    else:
        $Camera2D.enabled = false
        
    #$AttackTimer.wait_time = ATTACKSPEED
    cdBar.size = Vector2(0,40)
    $PlayerName.text = str(player_id)
    player_color = GameManager.COLORS[randf_range(0,3)]
    
func get_input():
    var input_direction = player_input.input_direction
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
    if attacking and canAttack:
        staffSprite.speed_scale = 1
        staffSprite.play("attack")
        canAttack = false
        attack_timer.start()
        shoot()
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
    mouse_position = player_input.mouse_position
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
    if attacking:
        attack_time = attack_timer.time_left
        cdBar.visible = true
        cdBar.size = Vector2(40 - (attack_time * 40),40)
    else:
        cdBar.visible = false
    
func _process(delta):
    handleCooldown()
    #username = $InputSynchronizer.username
    #$PlayerName.text = username
    #set_color(COLORS[randf_range(0,3)])
    #displayInventory()
           
    if not multiplayer.is_server() || MultiplayerManager.host_mode_enabled:
        _apply_animation(delta)
        set_color(player_color)
        
         
func _physics_process(delta):
    if is_multiplayer_authority():
        _apply_movement_from_input(delta)

func _on_attack_timer_timeout():
    attacking = false
    canAttack = true

func shoot():
    var bullet = bullet_scene.instantiate()

    var player_vector : Vector2 = marker.global_position
    bullet.bullet_velocity = player_vector.direction_to(mouse_position)
    bullet.look_at(mouse_position)
    bullet.position = marker.global_position
    bullets.add_child(bullet)

