class_name Eye
extends Node2D


# -   RIGHT is 0.0.
# -   LEFT is PI.
# -   DOWN is PI/2.
# -   UP is PI*3/2.
const _SIDEWAYS_GAZE_ANGLE_THRESHOLD := PI * 11.0 / 180.0
const _RIGHT_GAZE_ANGLE_THRESHOLD := PI / 2.0 - _SIDEWAYS_GAZE_ANGLE_THRESHOLD
const _LEFT_GAZE_ANGLE_THRESHOLD := PI / 2.0 + _SIDEWAYS_GAZE_ANGLE_THRESHOLD

const _DOWNWARD_GAZE_HEIGHT_THRESHOLD := 128.0
const _WIDE_EYED_HEIGHT_THRESHOLD := -64.0
const _NARROW_EYED_DURATION := 2.0

const _FLAME_SPEED_AGGRAVATED := 2.0

var _last_narrow_start_time := -INF


func _process(_delta: float) -> void:
    if Su.is_precomputing_platform_graphs or \
            Sc.level_session._is_destroyed:
        return
    
    _track_ring()


func _track_ring() -> void:
    var direction := EyeDirection.UNKNOWN
    var flame_speed_scale := 1.0
    
    var ring_position: Vector2 = Sc.level.get_ring_position()
    
    if Sc.time.get_scaled_play_time() < \
            _last_narrow_start_time + _NARROW_EYED_DURATION:
        direction = EyeDirection.NARROW
        flame_speed_scale = _FLAME_SPEED_AGGRAVATED
    elif ring_position == Vector2.INF:
        direction = EyeDirection.CENTER
    else:
        var angle_to_ring := \
                fmod(self.position.angle_to_point(ring_position) + PI * 2, PI)
        
        if ring_position.y < _WIDE_EYED_HEIGHT_THRESHOLD:
            direction = EyeDirection.WIDE
            flame_speed_scale = _FLAME_SPEED_AGGRAVATED
        elif angle_to_ring < _RIGHT_GAZE_ANGLE_THRESHOLD:
            direction = EyeDirection.RIGHT
        elif angle_to_ring > _LEFT_GAZE_ANGLE_THRESHOLD:
            direction = EyeDirection.LEFT
        elif ring_position.y > _DOWNWARD_GAZE_HEIGHT_THRESHOLD:
            direction = EyeDirection.DOWN
        else:
            direction = EyeDirection.CENTER
    
    set_direction(direction)
    
    $Flames.speed_scale = flame_speed_scale


func set_direction(direction: int) -> void:
    for sprite in Sc.utils.get_children_by_type(self, Sprite):
        sprite.visible = false
    
    var sprite := get_sprite_for_direction(direction)
    sprite.visible = true


func trigger_narrow() -> void:
    _last_narrow_start_time = Sc.time.get_scaled_play_time()


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
