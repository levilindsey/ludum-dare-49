tool
class_name Hero
extends SurfacerCharacter


const _MIN_START_DELAY := 0.0
const _MAX_START_DELAY := 2.0

var glow: Light2D


func _ready() -> void:
    assert(default_behavior is DefaultBehavior)
    
    var delay := \
            randf() * (_MAX_START_DELAY - _MIN_START_DELAY) + _MIN_START_DELAY
    Sc.time.set_timeout(funcref(self, "trigger_move_to_goal"), delay)
    
    glow = get_node("Glow")
    assert(is_instance_valid(glow))
    glow.visible = false


func trigger_move_to_goal() -> void:
    Sc.logger.error("Abstract Hero.trigger_move_to_goal is not implemented.")
    pass


func stop() -> void:
    default_behavior.trigger(false)


func _process_sounds() -> void:
    if just_triggered_jump:
        Sc.audio.play_sound("bobbit_jump")
    
    if surface_state.just_left_air:
        Sc.audio.play_sound("bobbit_land")
    elif surface_state.just_touched_surface:
        Sc.audio.play_sound("bobbit_hit_surface")


func set_is_ring_bearer(is_ring_bearer: bool) -> void:
    glow.visible = is_ring_bearer


# FIXME: -------------------- Call this.
func on_knock_off() -> void:
    Sc.level.on_hero_knocked_off()
    if Sc.level.ring_bearer == self:
        Sc.level._update_ring_bearer()
        Sc.level.toss_ring(self, Sc.level.ring_bearer)
