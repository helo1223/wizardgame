extends CharacterBody2D


const SPEED = 100.0
const ATTACKSPEED = 1.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


@onready var mageSprite = $MageSprite
@onready var staffSprite = $MageSprite.get_node("StaffSprite")
@onready var cdBar = $Bar

var attacking = false
var canAttack = true
var staffFlipped = false

var inventory_visible = false

func _ready():
    cdBar.size = Vector2(0,40)

func get_input():
    var input_direction = Input.get_vector("left", "right", "up", "down")
    velocity = input_direction * SPEED
        
    if Input.is_action_just_pressed("inventory"):
        inventory_visible = !inventory_visible 
        
    if !attacking:
        attacking = Input.is_action_just_pressed("attack")
        

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
    if staffSprite:
        if attacking:
            if canAttack:
                staffSprite.speed_scale = 1
                canAttack = false
                staffSprite.play("attack")
                $AttackTimer.start()
        else:
            if velocity != Vector2.ZERO:
                    staffSprite.animation =  "walk"
                    if velocity.x < 0:
                        staffSprite.speed_scale = -1
                    else:
                        staffSprite.speed_scale = 1
            else:
                staffSprite.animation =  "idle"
                staffSprite.speed_scale = 1
        
        var mouse_position = get_global_mouse_position()
        if mouse_position < position:
            mageSprite.flip_h = true
            staffSprite.flip_v = true
        else:
            mageSprite.flip_h = false
            staffSprite.flip_v = false
        staffSprite.look_at(mouse_position) 	

func handleCooldown():
    if canAttack:
        cdBar.visible = false
    else:
        cdBar.visible = true
        cdBar.size = Vector2(40 - ($AttackTimer.time_left * 40),40)

func _physics_process(delta):
    get_input()
    move_and_slide()
    
func _process(delta):
    handleMageAnimation()
    handleStaffAnimation()
    handleCooldown()
    handleAttack()
    #displayInventory()
    
func handleAttack():
    if canAttack && attacking:
        pass

func displayInventory():
    $Inventory.visible = inventory_visible

func _on_attack_timer_timeout():
    canAttack = true

func _on_staff_sprite_animation_finished():
    if staffSprite.animation == "attack":
        attacking = false
