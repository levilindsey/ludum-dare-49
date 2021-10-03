tool
class_name Hero
extends Character


var glow: Light2D


func _ready() -> void:
    glow = get_node("Glow")
    assert(is_instance_valid(glow))
    glow.visible = false


func set_is_ring_bearer(is_ring_bearer: bool) -> void:
    glow.visible = is_ring_bearer

