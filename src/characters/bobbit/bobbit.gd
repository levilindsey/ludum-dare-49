tool
class_name Bobbit
extends Hero


const ENCOUNTER_BOOST_MAGNITUDE := 100.0
const MAX_ENCOUNTER_COUNT := 2


func _ready() -> void:
    $EncounterBehavior.boost_magnitude = ENCOUNTER_BOOST_MAGNITUDE
    $EncounterBehavior.max_encounter_count = MAX_ENCOUNTER_COUNT


func trigger_move() -> void:
    $MoveToGoalBehavior.trigger(false)
