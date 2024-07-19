extends Area2D

var speed = 150
@onready var sprite = $Sprite

func _physics_process(delta):
    var velocity = Vector2.RIGHT.rotated(rotation)
    global_position += velocity * speed * delta
    

func _on_fade_timer_timeout():
    queue_free()
