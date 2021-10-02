class_name Eye
extends Node2D


func set_direction(direction: int) -> void:
    for sprite in Sc.utils.get_children_by_type(self, Sprite):
        sprite.visible = false
    
    var sprite := get_sprite_for_direction(direction)
    sprite.visible = true


func get_sprite_for_direction(direction: int) -> Sprite:
    match direction:
        EyeDirection.CENTER:
            return $EyeCenter as Sprite
        EyeDirection.LEFT:
            return $EyeLeft as Sprite
        EyeDirection.RIGHT:
            return $EyeRight as Sprite
        EyeDirection.DOWN:
            return $EyeDown as Sprite
        EyeDirection.NARROW:
            return $EyeNarrow as Sprite
        EyeDirection.WIDE:
            return $EyeWide as Sprite
        _:
            Sc.logger.error()
            return null
