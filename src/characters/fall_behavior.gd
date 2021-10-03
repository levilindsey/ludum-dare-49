tool
class_name FallBehavior, \
"res://addons/surfacer/assets/images/editor_icons/run_away_behavior.png"
extends Behavior


const NAME := "fall"
const IS_ADDED_MANUALLY := true
const USES_MOVE_TARGET := false
const INCLUDES_MID_MOVEMENT_PAUSE := false
const INCLUDES_POST_MOVEMENT_PAUSE := false
const COULD_RETURN_TO_START_POSITION := false


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


func _on_physics_process(delta: float) -> void:
    ._on_physics_process(delta)
    
    if !is_active:
        return
    
    if character.surface_state.is_grabbing_surface:
        var fall_distance := \
                character.position.y - \
                latest_activate_start_position.y
        character._on_fall_finished(fall_distance)


func _move() -> int:
    # Do nothing.
    return BehaviorMoveResult.VALID_MOVE
