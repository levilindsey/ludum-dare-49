tool
class_name HeroAnimator
extends ScaffolderCharacterAnimator


export var hero_name: String setget _set_hero_name


func _ready() -> void:
    _assign_textures()


func _assign_textures() -> void:
    if hero_name == "":
        return
    
    var jump_texture_path := \
            "res://assets/images/characters/%s_jump.png" % hero_name
    var running_texture_path := \
            "res://assets/images/characters/%s_running.png" % hero_name
    var standing_texture_path := \
            "res://assets/images/characters/%s_standing.png" % hero_name
    var knocked_texture_path := \
            "res://assets/images/characters/%s_knocked.png" % hero_name
    var fallen_texture_path := \
            "res://assets/images/characters/%s_fallen.png" % hero_name
    
    var jump_texture := load(jump_texture_path)
    var running_texture := load(running_texture_path)
    var standing_texture := load(standing_texture_path)
    var knocked_texture := load(knocked_texture_path)
    var fallen_texture := load(fallen_texture_path)
    
    $Walk.texture = running_texture
    $ClimbUp.texture = standing_texture
    $ClimbDown.texture = standing_texture
    $CrawlOnCeiling.texture = standing_texture
    $Rest.texture = standing_texture
    $RestOnWall.texture = standing_texture
    $RestOnCeiling.texture = standing_texture
    $JumpFall.texture = jump_texture
    $JumpRise.texture = jump_texture
    $Knocked.texture = knocked_texture
    $Fallen.texture = fallen_texture


func _set_hero_name(value: String) -> void:
    hero_name = value
    _assign_textures()
