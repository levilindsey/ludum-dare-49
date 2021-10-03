tool
class_name EncounterBehavior, \
"res://addons/surfacer/assets/images/editor_icons/collide_behavior.png"
extends Behavior


const NAME := "encounter"
const IS_ADDED_MANUALLY := true
const USES_MOVE_TARGET := true
const INCLUDES_MID_MOVEMENT_PAUSE := false
const INCLUDES_POST_MOVEMENT_PAUSE := false
const COULD_RETURN_TO_START_POSITION := false

const MAX_TARGET_DISTANCE_THRESHOLD := 64.0
const BOOST_MAGNITUDE_DEFAULT := 80.0
const MAX_ENCOUNTER_COUNT_DEFAULT := 3
const BOOST_ANGLE := -PI / 6.0
var BOOST_RIGHT_DIRECTION := Vector2.RIGHT.rotated(BOOST_ANGLE)
var BOOST_LEFT_DIRECTION := BOOST_RIGHT_DIRECTION.reflect(Vector2.UP)

var encounter_surface: Surface
var is_initiator: bool

var boost_magnitude := BOOST_MAGNITUDE_DEFAULT
var max_encounter_count := MAX_ENCOUNTER_COUNT_DEFAULT

var encounter_count := 0


func _init().(
        NAME,
        IS_ADDED_MANUALLY,
        USES_MOVE_TARGET,
        INCLUDES_MID_MOVEMENT_PAUSE,
        INCLUDES_POST_MOVEMENT_PAUSE,
        COULD_RETURN_TO_START_POSITION) -> void:
    pass


#func _on_active() -> void:
#    ._on_active()


#func _on_ready_to_move() -> void:
#    ._on_ready_to_move()


#func _on_inactive() -> void:
#    ._on_inactive()


#func _on_navigation_ended(did_navigation_finish: bool) -> void:
#    ._on_navigation_ended(did_navigation_finish)


#func _on_physics_process(delta: float) -> void:
#    ._on_physics_process(delta)


func on_collided() -> void:
    if !is_active:
        return
    
    if !character.surface_state.is_grabbing_surface or \
            !move_target.surface_state.is_grabbing_surface:
        return
    
    character._log(
            "Enc collided",
            "with=%s" % move_target.character_name,
            CharacterLogType.BEHAVIOR,
            false)
    
    if character.navigation_state.is_currently_navigating:
        character.navigator.stop()
    
    var is_self_to_the_left := character.position.x < move_target.position.x
    var boost_direction := \
            BOOST_LEFT_DIRECTION if \
            is_self_to_the_left else \
            BOOST_RIGHT_DIRECTION
    var boost := boost_direction * boost_magnitude
    character.force_boost(boost)
    
    encounter_count += 1
    
    # FIXME: ------------------------------
    # - Get this working so that the characters can bounce off ecah other a
    #   couple times before falling.
    character._fall()
    move_target._fall()
#    if encounter_count == max_encounter_count:
#        character._fall()
#    _pause_mid_movement()


func _move() -> int:
    assert(is_instance_valid(encounter_surface))
    assert(encounter_surface.side == SurfaceSide.FLOOR)
    
    if !is_instance_valid(move_target) or \
            character.position.distance_squared_to(move_target.position) > \
            MAX_TARGET_DISTANCE_THRESHOLD:
        character.trigger_move()
        return BehaviorMoveResult.VALID_MOVE
    
    var self_close_end_point := \
            encounter_surface.first_point if \
            character.position.x < encounter_surface.center.x else \
            encounter_surface.last_point
    var move_target_close_end_point := \
            encounter_surface.first_point if \
            move_target.position.x < encounter_surface.center.x else \
            encounter_surface.last_point
    
    var target_point: Vector2
    if character.surface_state.grabbed_surface == encounter_surface:
        if move_target.surface_state.grabbed_surface == encounter_surface:
            # Both are already on the encounter surface.
            if is_initiator:
                target_point = move_target.position
            else:
                # Just wait in place for the other character to come to us.
                return BehaviorMoveResult.VALID_MOVE
        else:
            target_point = move_target_close_end_point
    else:
        target_point = self_close_end_point
    
    var destination := PositionAlongSurfaceFactory \
            .create_position_offset_from_target_point(
                target_point,
                encounter_surface,
                character.movement_params.collider,
                true,
                true)
    
    var path := _find_path(
            destination,
            false)
    if !is_instance_valid(path):
        return BehaviorMoveResult.ERROR
    
    var is_navigation_valid: bool = character.navigator.navigate_path(path)
    if !is_navigation_valid:
        return BehaviorMoveResult.ERROR
    
    return BehaviorMoveResult.VALID_MOVE
