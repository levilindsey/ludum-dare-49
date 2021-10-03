tool
class_name Character
extends SurfacerCharacter


const CHARACTER_SOUNDS := {
    baldrock = {
        spawn = "baldrock",
        land = "land",
        jump = "jump_lower",
        knocked = "knocked_villain",
    },
    bobbit = {
        spawn = "bobbit",
        land = "land",
        jump = "jump_high",
        knocked = "knocked_hero",
    },
    dwarf = {
        spawn = "dwarf",
        land = "land",
        jump = "jump_low",
        knocked = "knocked_hero",
    },
    elf = {
        spawn = "elf",
        land = "land",
        jump = "jump_low",
        knocked = "knocked_hero",
    },
    orc = {
        spawn = "orc",
        land = "land",
        jump = "jump_low",
        knocked = "knocked_villain",
    },
    wizard = {
        spawn = "wizard",
        land = "land",
        jump = "jump_lower",
        knocked = "knocked_hero",
    },
}


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
var was_knocked_off := false
var just_knocked_off := false
var has_played_spawn_sound := false


func _ready() -> void:
    assert(default_behavior is DefaultBehavior)
    assert(is_instance_valid(get_behavior(FallBehavior)))
    
    var delay := \
            randf() * (_MAX_START_DELAY - _MIN_START_DELAY) + _MIN_START_DELAY
    Sc.time.set_timeout(funcref(self, "trigger_move"), delay, [], TimeType.PLAY_PHYSICS_SCALED)


func _process_physics(delta: float) -> void:
    just_knocked_off = was_knocked_off != is_knocked_off
    was_knocked_off = is_knocked_off


func trigger_move() -> void:
    Sc.logger.error("Abstract Character.trigger_move is not implemented.")


func trigger_encounter(enemy: Character) -> void:
    if self.behavior is EncounterBehavior or \
            enemy.behavior is EncounterBehavior or \
            self.behavior is FallBehavior or \
            enemy.behavior is FallBehavior:
        return
    
    var displacement := enemy.position - self.position
    var is_enemy_to_the_left := displacement.x < 0
    var is_enemy_moving := enemy.velocity.x != 0
    var is_enemy_moving_left := enemy.velocity.x < 0
    var is_self_moving := self.velocity.x != 0
    var is_self_moving_left := self.velocity.x < 0
    
    var is_enemy_approaching := \
            is_enemy_moving and \
            (is_enemy_to_the_left != is_enemy_moving_left)
    var is_self_approaching := \
            is_self_moving and \
            (is_enemy_to_the_left == is_self_moving_left)
    
    var self_target_surface: Surface
    if self.navigation_state.is_currently_navigating:
        self_target_surface = \
                self.navigator.edge.end_position_along_surface.surface
    if !is_instance_valid(self_target_surface):
        self_target_surface = \
                self.surface_state.last_position_along_surface.surface
    
    var enemy_target_surface: Surface
    if enemy.navigation_state.is_currently_navigating:
        enemy_target_surface = \
                enemy.navigator.edge.end_position_along_surface.surface
    if !is_instance_valid(enemy_target_surface):
        enemy_target_surface = \
                enemy.surface_state.last_position_along_surface.surface
    
    var encounter_surface: Surface
    if is_self_approaching:
        encounter_surface = self_target_surface
    elif is_enemy_approaching:
        encounter_surface = enemy_target_surface
    elif is_self_moving:
        encounter_surface = self_target_surface
    elif is_enemy_moving:
        encounter_surface = enemy_target_surface
    else:
        encounter_surface = enemy_target_surface
    
    var self_encounter_behavior: EncounterBehavior = \
            self.get_behavior(EncounterBehavior)
    var enemy_encounter_behavior: EncounterBehavior = \
            enemy.get_behavior(EncounterBehavior)
    
    self_encounter_behavior.is_initiator = true
    enemy_encounter_behavior.is_initiator = true
    
    self_encounter_behavior.encounter_surface = encounter_surface
    enemy_encounter_behavior.encounter_surface = encounter_surface
    
    self_encounter_behavior.move_target = enemy
    enemy_encounter_behavior.move_target = self
    
    self_encounter_behavior.trigger(false)
    enemy_encounter_behavior.trigger(false)


func stop() -> void:
    default_behavior.trigger(false)


func _process_sounds() -> void:
    var sounds_config: Dictionary = CHARACTER_SOUNDS[character_name]
    
    if !has_played_spawn_sound:
        Sc.audio.play_sound(sounds_config.spawn)
        has_played_spawn_sound = true
    elif just_triggered_jump:
        Sc.audio.play_sound(sounds_config.jump)
    elif surface_state.just_left_air or \
            surface_state.just_touched_surface:
        Sc.audio.play_sound(sounds_config.land)
    elif just_knocked_off:
        Sc.audio.play_sound(sounds_config.knocked)


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
    
    # FIXME: --------------- Cleanup? Going to try always away from center.
#    var boost: Vector2
#    if !surface_state.is_grabbing_surface:
#        if velocity.x < 0:
#            boost = bounce_boost_right
#        else:
#            boost = bounce_boost_left
#    else:
#        if randf() > 0.5:
#            boost = bounce_boost_left
#        else:
#            boost = bounce_boost_right
    var boost := \
            bounce_boost_right if \
            position.x > 0 else \
            bounce_boost_left
    
    force_boost(boost)
    
    navigator.stop()
    get_behavior(FallBehavior).trigger(true)
    
    # This should only be needed in case the FallBehavior incorrectly didn't
    # end up triggering it.
    Sc.time.set_timeout(funcref(self, "_on_fall_finished"), 0.6, [10000.0], TimeType.PLAY_PHYSICS_SCALED)


func _on_fall_finished(fall_distance: float) -> void:
    if !is_falling:
        return
    
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
    
    navigator.stop()
    get_behavior(DefaultBehavior).trigger(true)
    
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
