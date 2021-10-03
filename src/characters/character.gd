tool
class_name Character
extends SurfacerCharacter


const _MIN_START_DELAY := 0.0
const _MAX_START_DELAY := 2.0

const _KNOCK_OFF_FALL_DISTANCE_THRESHOLD := 64.0
const _FADE_OUT_DURATION := 1.0
const _FADE_OUT_DELAY := 1.0

const _BOUNCE_MAGNITUDE := 500.0
const _BOUNCE_ANGLE := -PI / 3.0

var _BOUNCE_NORMAL_RIGHT := Vector2.RIGHT.rotated(_BOUNCE_ANGLE)
var _BOUNCE_NORMAL_LEFT := _BOUNCE_NORMAL_RIGHT.reflect(Vector2.UP)
var _BOUNCE_BOOST_RIGHT := _BOUNCE_NORMAL_RIGHT * _BOUNCE_MAGNITUDE
var _BOUNCE_BOOST_LEFT := _BOUNCE_NORMAL_LEFT * _BOUNCE_MAGNITUDE

var is_falling := false
var is_knocked_off := false


func _ready() -> void:
    assert(default_behavior is DefaultBehavior)
    assert(is_instance_valid(get_behavior(FallBehavior)))
    
    var delay := \
            randf() * (_MAX_START_DELAY - _MIN_START_DELAY) + _MIN_START_DELAY
    Sc.time.set_timeout(funcref(self, "trigger_move"), delay)


func trigger_move() -> void:
    Sc.logger.error("Abstract Character.trigger_move is not implemented.")


func stop() -> void:
    default_behavior.trigger(false)


func _process_sounds() -> void:
    if just_triggered_jump:
        Sc.audio.play_sound("bobbit_jump")
    
    if surface_state.just_left_air:
        Sc.audio.play_sound("bobbit_land")
    elif surface_state.just_touched_surface:
        Sc.audio.play_sound("bobbit_hit_surface")


func _process_animation() -> void:
    if is_falling:
        animator.play("Knocked")
    elif is_knocked_off:
        animator.play("Fallen")
    else:
        ._process_animation()


func on_tremor() -> void:
    if is_falling:
        return
    
    is_falling = true
    current_max_horizontal_speed = _BOUNCE_MAGNITUDE
    
    var boost: Vector2
    if !surface_state.is_grabbing_surface:
        if velocity.x < 0:
            boost = _BOUNCE_BOOST_RIGHT
        else:
            boost = _BOUNCE_BOOST_LEFT
    else:
        if randf() > 0.5:
            boost = _BOUNCE_BOOST_LEFT
        else:
            boost = _BOUNCE_BOOST_RIGHT
    
    force_boost(boost)
    
    navigator.stop()
    get_behavior(FallBehavior).trigger(true)


func _on_fall_finished(fall_distance) -> void:
    is_falling = false
    current_max_horizontal_speed = movement_params.max_horizontal_speed_default
    
    if fall_distance > _KNOCK_OFF_FALL_DISTANCE_THRESHOLD:
        # Ack, ugh, RIP.
        on_knock_off()
    else:
        # Try, try again.
        trigger_move()


func on_knock_off() -> void:
    if is_knocked_off:
        return
    
    is_knocked_off = true
    
    Sc.level.on_hero_knocked_off()
    
    if Sc.level.ring_bearer == self:
        Sc.level._update_ring_bearer()
        Sc.level.toss_ring(self, Sc.level.ring_bearer)
    
    Sc.time.tween_property(
            self,
            "modulate:a",
            1.0,
            0.0,
            _FADE_OUT_DURATION,
            "ease_out",
            _FADE_OUT_DELAY,
            TimeType.PLAY_PHYSICS_SCALED,
            funcref(self, "_on_faded"))


func _on_faded() -> void:
    Sc.level.remove_character(self)
