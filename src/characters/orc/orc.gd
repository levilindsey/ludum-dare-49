tool
class_name Orc
extends Villain


const ENCOUNTER_BOOST_MAGNITUDE := 80.0
const MAX_ENCOUNTER_COUNT := 13


func _ready() -> void:
    $EncounterBehavior.boost_magnitude = ENCOUNTER_BOOST_MAGNITUDE
    $EncounterBehavior.max_encounter_count = MAX_ENCOUNTER_COUNT



# FIXME: Fix this hack.
var interval := Sc.time.set_interval(funcref(self, "_check_behavior"), 2.0)

func _destroy() -> void:
    Sc.time.clear_interval(interval)
    ._destroy()

func _check_behavior() -> void:
    if !surface_state.did_move_last_frame and \
            !surface_state.did_move_frame_before_last and \
            is_instance_valid(Sc.level.ring_bearer) and \
            !is_knocked_off and \
            !_is_destroyed:
        trigger_move()




func trigger_move() -> void:
    if is_instance_valid(Sc.level.ring_bearer):
        $CollideBehavior.move_target = Sc.level.ring_bearer
        $CollideBehavior.trigger(false)
    else:
        get_behavior(DefaultBehavior).trigger(false)


func _physics_process(_delta: float) -> void:
    if Su.is_precomputing_platform_graphs or \
            Sc.level_session._is_destroyed:
        return
    
    if _is_destroyed or \
            !is_instance_valid(behavior) or \
            !is_instance_valid(Sc.level.ring_bearer):
        return
 
        # FIXME: ---------- The EncounterBehavior system is broken right now.
#    if behavior.behavior_name == "collide" and \
#            Sc.level.ring_bearer.behavior.behavior_name == "move_to_goal":
#        var current_distance_squared := \
#                position.distance_squared_to(Sc.level.ring_bearer.position)
#        if current_distance_squared <= \
#                TRIGGER_ENCOUNTER_DISTANCE_SQUARED_THRESHOLD:
#            trigger_encounter(Sc.level.ring_bearer)
