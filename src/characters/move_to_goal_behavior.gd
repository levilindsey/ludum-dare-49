tool
class_name MoveToGoalBehavior, \
"res://addons/surfacer/assets/images/editor_icons/collide_behavior.png"
extends Behavior


const NAME := "move_to_goal"
const IS_ADDED_MANUALLY := true
const USES_MOVE_TARGET := false
const INCLUDES_MID_MOVEMENT_PAUSE := true
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


#func _on_physics_process(delta: float) -> void:
#    ._on_physics_process(delta)


func _move() -> int:
    var path := _find_path(
            Sc.level.goal_position,
            false)
    if !is_instance_valid(path):
        # FIXME: LEFT OFF HERE: ------------------
        Sc.logger.warning()
        return BehaviorMoveResult.ERROR
    
    if path.edges.size() != 1 or \
            !(path.edges[0] is IntraSurfaceEdge):
        var first_jump_edge: Edge
        for edge in path.edges:
            if edge is JumpFromSurfaceEdge:
                first_jump_edge = edge
                break
        assert(is_instance_valid(first_jump_edge))
        
        path = _find_path(
                first_jump_edge.end_position_along_surface,
                _is_first_move_since_active)
        if !is_instance_valid(path):
            Sc.logger.error()
            return BehaviorMoveResult.ERROR
    
    var is_navigation_valid: bool = character.navigator.navigate_path(path)
    if !is_navigation_valid:
        Sc.logger.error()
        return BehaviorMoveResult.ERROR
    
    return BehaviorMoveResult.VALID_MOVE
