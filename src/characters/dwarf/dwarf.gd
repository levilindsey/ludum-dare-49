tool
class_name Dwarf
extends Hero


const ENCOUNTER_BOOST_MAGNITUDE := 50.0
const MAX_ENCOUNTER_COUNT := 3


func _ready() -> void:
    $EncounterBehavior.boost_magnitude = ENCOUNTER_BOOST_MAGNITUDE
    $EncounterBehavior.max_encounter_count = MAX_ENCOUNTER_COUNT


func trigger_move() -> void:
    $MoveToGoalBehavior.trigger(false)
