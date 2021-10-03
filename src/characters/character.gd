tool
class_name Character
extends SurfacerCharacter


const _MIN_START_DELAY := 0.0
const _MAX_START_DELAY := 2.0

const _KNOCK_OFF_FALL_DISTANCE_THRESHOLD := 64.0
const _FADE_OUT_DURATION := 1.0
const _FADE_OUT_DELAY := 1.0

const _BOUNCE_MAGNITUDE := 450.0
const _BOUNCE_MAGNITUDE_MAX_OFFSET := 150.0
const _BOUNCE_ANGLE := -PI / 3.0
const _BOUNCE_ANGLE_MAX_OFFSET := PI / 9.0

const _BOUNCE_MAGNITUDE_MAX_OFFSET_FOR_HEIGHT := 150.0
const _BOUNCE_MAGNITUDE_MAX_OFFSET_FOR_HEIGHT_MIN_HEIGHT := 192.0
const _BOUNCE_MAGNITUDE_MAX_OFFSET_FOR_HEIGHT_MAX_HEIGHT := -128.0

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
    _fall()


func _fall() -> void:
    if is_falling:
        return
    
    is_falling = true
    
    var bounce_magnitude_height_offset_progress := clamp(
            (_BOUNCE_MAGNITUDE_MAX_OFFSET_FOR_HEIGHT_MIN_HEIGHT - \
                self.position.y) / \
            (_BOUNCE_MAGNITUDE_MAX_OFFSET_FOR_HEIGHT_MIN_HEIGHT - \
                _BOUNCE_MAGNITUDE_MAX_OFFSET_FOR_HEIGHT_MAX_HEIGHT),
            0.0,
            1.0)
    var bounce_magnitude_height_offset := \
            _BOUNCE_MAGNITUDE_MAX_OFFSET_FOR_HEIGHT * \
            bounce_magnitude_height_offset_progress
    var bounce_magnitude_random_offset := \
            randf() * _BOUNCE_MAGNITUDE_MAX_OFFSET
    var bounce_magnitude := \
            _BOUNCE_MAGNITUDE + \
            bounce_magnitude_height_offset + \
            bounce_magnitude_random_offset
    
    var bounce_angle := \
            _BOUNCE_ANGLE - \
            randf() * _BOUNCE_ANGLE_MAX_OFFSET
    
    var bounce_normal_right := Vector2.RIGHT.rotated(bounce_angle)
    var bounce_normal_left := bounce_normal_right.reflect(Vector2.UP)
    var bounce_boost_right := bounce_normal_right * bounce_magnitude
    var bounce_boost_left := bounce_normal_left * bounce_magnitude
    
    current_max_horizontal_speed = bounce_magnitude
    
    var boost: Vector2
    if !surface_state.is_grabbing_surface:
        if velocity.x < 0:
            boost = bounce_boost_right
        else:
            boost = bounce_boost_left
    else:
        if randf() > 0.5:
            boost = bounce_boost_left
        else:
            boost = bounce_boost_right
    
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


func _show_exclamation_mark_throttled() -> void:
    Sc.annotators.add_transient(ExclamationMarkAnnotator.new(
            self,
            collider.half_width_height.y + 20.0,
            primary_annotation_color,
            secondary_annotation_color,
            exclamation_mark_width_start,
            exclamation_mark_length_start,
            exclamation_mark_stroke_width_start,
            exclamation_mark_duration))
