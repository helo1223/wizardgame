extends CharacterBody2D


const SPEED = 100.0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


@onready var mageSprite = $Mage
@onready var playerNameLabel = $PlayerName
@onready var bullets = $Bullets

@onready var staffs = [$Mage/Staff, $Mage/Staff2]
var active_staff_index = 0
var active_staff = null
var username = ""

var attacking = false
var canAttack = true
var mouse_position = null

var inventory_visible = false
                
var player_color = GameManager.COLORS[GameManager.selected_color]
                
func set_color(color):
    mageSprite.material.set_shader_parameter("target_color", color)
    
func _apply_animation(_delta):
    handleMageAnimation()
    handleStaffAnimation()
    
func _apply_movement_from_input(_delta):
    get_input()
    move_and_slide()

func _ready():        
    #$AttackTimer.wait_time = ATTACKSPEED
    $PlayerName.text = "Player"
    active_staff = staffs[active_staff_index]
    active_staff.color = player_color
    GameManager.set_color(active_staff.sprite, player_color)
    staffs[1].color = GameManager.COLORS[3]
    staffs[1].attack_speed = 2.0
    
func get_input():
    var next_staff = Input.is_action_just_pressed("next_staff")
    var prev_staff = Input.is_action_just_pressed("prev_staff")
    if next_staff:
        switch_active_staff(1)
    elif prev_staff:
        switch_active_staff(-1)
    
    var input_direction = Input.get_vector("left", "right", "up", "down")
    velocity = input_direction * SPEED
        
    if Input.is_action_just_pressed("inventory"):
        inventory_visible = !inventory_visible 
        
    if Input.is_action_pressed("attack"):
        attack()
        
    if Input.is_action_just_pressed("exit"):
        get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")

func switch_active_staff(dir):
    if dir == 1:
        if active_staff_index < staffs.size()-1:
            active_staff_index +=1
        else:
            active_staff_index = 1
    elif dir == -1 && dir < 0:
        if active_staff_index > 0:
            active_staff_index -= 1
        else:
            active_staff_index = staffs.size()-1
    active_staff.visible = false
    active_staff.attacking = false
    active_staff.state = "idle"
    active_staff = staffs[active_staff_index]
    GameManager.set_color(active_staff.sprite, active_staff.color)
    active_staff.visible = true

func attack():
    active_staff.shoot()

        
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
    if not active_staff.attacking:
        if velocity != Vector2.ZERO:
            active_staff.set_walk(velocity)
        else:
            active_staff.set_idle()
            
    handle_mouse_position()
    

    
func handle_mouse_position():
    #Flip sprites
    mouse_position = get_global_mouse_position()
    if mouse_position:
        if mouse_position < position:
            mageSprite.flip_h = true
            if not attacking: 
                #active_staff.sprite.speed_scale *= -1
                active_staff.sprite.scale.y = -1
        else:
            mageSprite.flip_h = false
            active_staff.sprite.scale.y = 1
            
        #Staff follows mouse
        active_staff.look_at(mouse_position) 	
    
func _process(delta):
    _apply_animation(delta)        
         
func _physics_process(delta):
    _apply_movement_from_input(delta)
