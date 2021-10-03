tool
class_name Orc
extends Villain


const ENCOUNTER_BOOST_MAGNITUDE := 80.0
const MAX_ENCOUNTER_COUNT := 3


func _ready() -> void:
    $EncounterBehavior.boost_magnitude = ENCOUNTER_BOOST_MAGNITUDE
    $EncounterBehavior.max_encounter_count = MAX_ENCOUNTER_COUNT


func trigger_move() -> void:
    if !is_instance_valid(Sc.level.ring_bearer):
        $CollideBehavior.move_target = Sc.level.ring_bearer
        $CollideBehavior.trigger(false)
    else:
        default_behavior.trigger(false)


func _physics_process(_delta: float) -> void:
    if behavior.behavior_name == "collide" and \
            !is_instance_valid(Sc.level.ring_bearer) and \
            Sc.level.ring_bearer.behavior_name == "move_to_goal":
        var current_distance_squared := \
                position.distance_squared_to(Sc.level.ring_bearer.position)
        if current_distance_squared <= \
                TRIGGER_ENCOUNTER_DISTANCE_SQUARED_THRESHOLD:
            trigger_encounter(Sc.level.ring_bearer)
