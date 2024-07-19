extends Node

var bullet_scene = preload("res://scenes/bullet.tscn")
@onready var marker = %Marker2D
@onready var attack_timer = $AttackTimer
@onready var player = get_parent().get_parent()
@onready var sprite = $Sprite


@export var attack_speed = 1.0
var state = "idle"
var can_attack = true
var attacking = false

var color = null

# Called when the node enters the scene tree for the first time.
func _ready():
    attack_timer.wait_time = 1.0 / attack_speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    attack_timer.wait_time = 1.0 / attack_speed
    if state == "attack":
        if sprite.frame > 6 && can_attack:
            var bullet = bullet_scene.instantiate()
            var player_vector : Vector2 = marker.global_position
            bullet.global_position = marker.global_position
            bullet.look_at(player.mouse_position)
            player.get_node("Bullets").add_child(bullet)
            GameManager.set_color(bullet.sprite, color)
            attack_timer.start()
            can_attack = false
            
func shoot():
    if can_attack:
        attacking = true
        state = "attack"
        sprite.speed_scale = attack_speed
        sprite.play(state)
        

func _on_attack_timer_timeout():
    can_attack = true
    attacking = false

func set_idle():
    state = "idle"
    sprite.speed_scale = 1
    sprite.play(state)

func set_walk(velocity):
    state = "walk"
    if velocity.x < 0:
        sprite.speed_scale = -1
    else:
        sprite.speed_scale = 1
    sprite.play(state)
