tool
class_name Villain
extends Character


const TRIGGER_ENCOUNTER_DISTANCE_SQUARED_THRESHOLD := 48.0 * 48.0


func _on_started_colliding(
        target: Node2D,
        layer_names: Array) -> void:
    if behavior.behavior_name == "encounter" and \
            behavior.move_target == target:
        behavior.on_collided()
        
        if behavior.move_target.behavior.behavior_name == "encounter":
            behavior.move_target.behavior.on_collided()
