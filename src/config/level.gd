tool
class_name Level
extends SurfacerLevel


var eye: Eye
var goal: Area2D
var goal_position: PositionAlongSurface


#func _load() -> void:
#    ._load()


func _start() -> void:
    eye = get_node("Eye")
    assert(is_instance_valid(eye))
    
    goal = get_node("Goal")
    assert(is_instance_valid(goal))
    
    goal_position = SurfaceFinder.find_closest_position_on_a_surface(
            goal.position,
            graph_parser.crash_test_dummies.bobbit,
            SurfaceReachability.ANY)
    
    eye.set_direction(EyeDirection.DOWN)
    
    ._start()


#func _destroy() -> void:
#    ._destroy()


#func _on_initial_input() -> void:
#    ._on_initial_input()


#func quit(immediately := true) -> void:
#    .quit(immediately)


#func _on_intro_choreography_finished() -> void:
#    ._on_intro_choreography_finished()


#func pause() -> void:
#    .pause()


#func on_unpause() -> void:
#    .on_unpause()


func _trigger_heroes_lose() -> void:
    # FIXME: -------------------------------
    pass
    
    if !Sc.level_session.is_ended:
        quit(true, false)


func _trigger_heroes_win() -> void:
    # FIXME: -------------------------------
    pass
    
    if !Sc.level_session.is_ended:
        quit(true, false)


func get_music_name() -> String:
    # FIXME: BOOTSTRAP: -------------------
    return "on_a_quest"


func get_slow_motion_music_name() -> String:
    # FIXME: BOOTSTRAP: -------------------
    # FIXME: Add slo-mo music
    return ""


func _on_Goal_body_entered(hero: Hero) -> void:
#    hero.stop()
    _trigger_heroes_win()
