tool
class_name Hero
extends Character


var glow: Light2D


func _ready() -> void:
    glow = get_node("Glow")
    assert(is_instance_valid(glow))
    glow.visible = false


func on_knock_off() -> void:
    .on_knock_off()
    
    if is_knocked_off:
        return
    
    Sc.level.on_hero_knocked_off()
    
    if Sc.level.ring_bearer == self:
        Sc.level._update_ring_bearer()
        Sc.level.toss_ring(self, Sc.level.ring_bearer)


func set_is_ring_bearer(is_ring_bearer: bool) -> void:
    glow.visible = is_ring_bearer

