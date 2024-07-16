extends Panel

var selected_mage_num : int = -1
var selection_changed : bool = true
var selection_anim_finished = false

@onready var mages = [$CharacterSelect/Mage1,
                      $CharacterSelect/Mage2,
                      $CharacterSelect/Mage3, 
                      $CharacterSelect/Mage4]
                    
@onready var select_button = $Select             

func _ready():
    for i in mages.size():
        GameManager.set_color(mages[i].get_node("AnimatedSprite2D"), GameManager.COLORS[i])
        
func _process(_delta):
    if selection_changed:
        for i in mages.size():
            var mage = mages[i]
            var selection = mage.get_node("Selection")
            var animation = mage.get_node("AnimatedSprite2D")
            if i == selected_mage_num:
                selection.visible = true
            else:
                selection.visible = false
                animation.play("idle")
                animation.stop()
        selection_changed = false
            
func change_selection(num):
    select_button.disabled = false
    if num != selected_mage_num:
        selected_mage_num = num
        selection_changed = true
    else:
        selection_changed = false
    mages[num].get_node("AnimatedSprite2D").play("select")

func _on_mage_selection(num):
    change_selection(num)

func _on_mage_mouse_entered(num):
    if num != selected_mage_num:
        mages[num].get_node("AnimatedSprite2D").play("idle")

func _on_mage_mouse_exited(num):
    if num != selected_mage_num:
        mages[num].get_node("AnimatedSprite2D").stop()


func _on_animated_sprite_2d_animation_finished(num):
    var anim : AnimatedSprite2D = mages[num].get_node("AnimatedSprite2D")
    if anim.animation == "select":
            anim.play("idle")


func _on_back_pressed():
    select_button.disabled = true
    selected_mage_num = -1
    selection_changed = true
    $".".visible = false
    $"../Home".visible = true


func _on_select_pressed():
    GameManager.selected_color = selected_mage_num
    get_tree().change_scene_to_file("res://scenes/game.tscn")
