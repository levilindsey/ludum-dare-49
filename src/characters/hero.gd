tool
class_name Hero
extends SurfacerCharacter


func _ready() -> void:
    assert(default_behavior is DefaultBehavior)
    trigger_move_to_goal()


func trigger_move_to_goal() -> void:
    Sc.logger.error("Abstract Hero.trigger_move_to_goal is not implemented.")
    pass


func stop() -> void:
    default_behavior.trigger(false)


func _process_sounds() -> void:
    if just_triggered_jump:
        Sc.audio.play_sound("bobbit_jump")
    
    if surface_state.just_left_air:
        Sc.audio.play_sound("bobbit_land")
    elif surface_state.just_touched_surface:
        Sc.audio.play_sound("bobbit_hit_surface")
