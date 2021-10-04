tool
class_name Villain
extends Character


const TRIGGER_ENCOUNTER_DISTANCE_SQUARED_THRESHOLD := 48.0 * 48.0

# FIXME: ----------------
# - Last-minute patch.
# - Undo this, and use EncounterBehavior.encounter_count instead.
var attack_count := 0


func _on_started_colliding(
        target: Node2D,
        layer_names: Array) -> void:
    ._on_started_colliding(target, layer_names)
    
    if Su.is_precomputing_platform_graphs or \
            Sc.level_session._is_destroyed or \
            _is_destroyed:
        return
    
    # FIXME: --------------- Old attempt.
#    if behavior.behavior_name == "encounter" and \
#            behavior.move_target == target:
#        behavior.on_collided()
#
#        if behavior.move_target.behavior.behavior_name == "encounter":
#            behavior.move_target.behavior.on_collided()
    
    _log("Vill coll",
            "villain=%s, hero=%s" % [
                self.character_name,
                target.character_name,
            ])
    
    var is_target_to_the_left := \
            target.position.x < self.position.x
    
    var self_encounter_behavior: EncounterBehavior = \
            self.get_behavior(EncounterBehavior)
    
    if is_instance_valid(target) and \
            target is Hero and \
            !target.is_falling and \
            !target.is_knocked_off:
        var target_encounter_behavior: EncounterBehavior = \
                target.get_behavior(EncounterBehavior)
        
        var boost_direction: Vector2 = \
                target_encounter_behavior.BOOST_LEFT_DIRECTION if \
                is_target_to_the_left else \
                target_encounter_behavior.BOOST_RIGHT_DIRECTION
        var boost_magnitude := 300.0
        var boost := boost_direction * boost_magnitude
        target.current_max_horizontal_speed = boost_magnitude
        target.force_boost(boost)
        
        target.on_knock_off()
        
        # FIXME: Hack; treating "encounter-count" as attack power.
        attack_count += target_encounter_behavior.max_encounter_count
    
    if attack_count >= self_encounter_behavior.max_encounter_count:
        var boost_direction: Vector2 = \
                self_encounter_behavior.BOOST_RIGHT_DIRECTION if \
                is_target_to_the_left else \
                self_encounter_behavior.BOOST_LEFT_DIRECTION
        var boost_magnitude := 100.0
        var boost := boost_direction * boost_magnitude
        self.current_max_horizontal_speed = boost_magnitude
        self.force_boost(boost)
        
        self.on_knock_off()
    
