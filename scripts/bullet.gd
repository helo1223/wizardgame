extends CharacterBody2D

var bullet_velocity : Vector2 = Vector2(0,0)
var speed = 50
# Called when the node enters the scene tree for the first time.
func _ready():
    pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    translate(velocity * delta)
    
func _physics_process(delta):
    var collision_info = move_and_collide(bullet_velocity.normalized() * delta * speed)
    var parent = get_parent().get_parent()
    print(collision_info == parent)
    if collision_info:
        queue_free()

func _on_fade_timer_timeout():
    queue_free()

