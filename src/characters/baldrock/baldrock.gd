tool
class_name Baldrock
extends Villain


const ENCOUNTER_BOOST_MAGNITUDE := 30.0
const MAX_ENCOUNTER_COUNT := 26


func _ready() -> void:
    $EncounterBehavior.boost_magnitude = ENCOUNTER_BOOST_MAGNITUDE
    $EncounterBehavior.max_encounter_count = MAX_ENCOUNTER_COUNT


func trigger_move() -> void:
    $MoveBackAndForthBehavior.trigger(false)


func _on_entered_proximity(
        target: Node2D,
        layer_names: Array) -> void:
    assert(target is Hero)
    if behavior.behavior_name != "encounter" and \
            target.behavior.behavior_name == "move_to_goal":
        target.trigger_encounter(self)
