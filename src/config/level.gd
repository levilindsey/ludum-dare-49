tool
class_name Level
extends SurfacerLevel


var eye: Eye
var goal: Area2D
var goal_position: PositionAlongSurface
var left_spawn_point: Vector2
var right_spawn_point: Vector2

var ring_bearer: Hero


#func _load() -> void:
#    ._load()


func _start() -> void:
    _parse_schedule()
    
    eye = get_node("Eye")
    assert(is_instance_valid(eye))
    
    goal = get_node("Goal")
    assert(is_instance_valid(goal))
    
    var left_spawn_point := get_node("LeftSpawnPoint")
    assert(is_instance_valid(left_spawn_point))
    self.left_spawn_point = left_spawn_point.position
    
    var right_spawn_point := get_node("RightSpawnPoint")
    assert(is_instance_valid(right_spawn_point))
    self.right_spawn_point = right_spawn_point.position
    
    goal_position = SurfaceFinder.find_closest_position_on_a_surface(
            goal.position,
            graph_parser.crash_test_dummies.bobbit,
            SurfaceReachability.ANY)
    
    eye.set_direction(EyeDirection.DOWN)
    
    ._start()


func _parse_schedule() -> void:
    assert(session.config.has("schedule"))
    assert(session.config.has("shake_cooldown_period"))
    
    for event in session.config.schedule:
        assert(event.has("type"))
        assert(event.has("time") and event.time is float)
        match event.type:
            "bobbit":
                session._bobbit_spawns.push_back(event)
            "dwarf":
                session._dwarf_spawns.push_back(event)
            "elf":
                session._elf_spawns.push_back(event)
            "wizard":
                session._wizard_spawns.push_back(event)
            "wave":
                session._waves.push_back(event)
            _:
                Sc.logger.error()
    
    session._bobbit_spawns.sort_custom(SpawnTimeComparator, "sort")
    session._dwarf_spawns.sort_custom(SpawnTimeComparator, "sort")
    session._elf_spawns.sort_custom(SpawnTimeComparator, "sort")
    session._wizard_spawns.sort_custom(SpawnTimeComparator, "sort")
    session._waves.sort_custom(SpawnTimeComparator, "sort")


func _physics_process(_delta: float) -> void:
    var current_time: float = Sc.time.get_scaled_play_time()
    
    if !session._is_hero_spawning_finished:
        session._next_bobbit_spawn_index = _flush_schedule(
                current_time,
                session._bobbit_spawns,
                session._next_bobbit_spawn_index,
                "_spawn_character")
        session._next_dwarf_spawn_index = _flush_schedule(
                current_time,
                session._dwarf_spawns,
                session._next_dwarf_spawn_index,
                "_spawn_character")
        session._next_elf_spawn_index = _flush_schedule(
                current_time,
                session._elf_spawns,
                session._next_elf_spawn_index,
                "_spawn_character")
        session._next_wizard_spawn_index = _flush_schedule(
                current_time,
                session._wizard_spawns,
                session._next_wizard_spawn_index,
                "_spawn_character")
        session._next_wave_index = _flush_schedule(
                current_time,
                session._waves,
                session._next_wave_index,
                "_trigger_wave")
        
        session._is_hero_spawning_finished = \
                session._next_bobbit_spawn_index >= \
                        session._bobbit_spawns.size() and \
                session._next_dwarf_spawn_index >= \
                        session._dwarf_spawns.size() and \
                session._next_elf_spawn_index >= \
                        session._elf_spawns.size() and \
                session._next_wizard_spawn_index >= \
                        session._wizard_spawns.size()
    
    _update_ring_bearer()
    
    session._hero_count = \
            _get_hero_count("bobbit") + \
            _get_hero_count("dwarf") + \
            _get_hero_count("elf") + \
            _get_hero_count("wizard")
    
    if session._is_hero_spawning_finished and \
            session._hero_count == 0:
        _trigger_heroes_lose()


func _get_hero_count(hero_name: String) -> int:
    return characters[hero_name].size() if \
            characters.has(hero_name) else \
            0


func _flush_schedule(
        current_time: float,
        schedule: Array,
        next_index: int,
        callback: String) -> int:
    var next_spawn_time: float = \
            schedule[next_index].time if \
            schedule.size() > next_index else \
            INF
    while current_time >= next_spawn_time:
        self.call(callback, schedule[next_index])
        next_index += 1
        next_spawn_time = \
                schedule[next_index].time if \
                schedule.size() > next_index else \
                INF
    return next_index


func _spawn_character(spawn_event_config: Dictionary) -> void:
    var character_name: String = spawn_event_config.type
    var spawns_on_left_side: bool = \
            !spawn_event_config.has("side") or \
            spawn_event_config.side == "l"
    var spawn_position := \
            left_spawn_point if \
            spawns_on_left_side else \
            right_spawn_point
    add_character(
            character_name,
            spawn_position,
            false,
            true)


func _trigger_wave(wave_event_config: Dictionary) -> void:
    # FIXME: ---------------------
    pass
    
    eye.trigger_narrow()


func _update_ring_bearer() -> void:
    var previous_ring_bearer := ring_bearer
    var highest_hero_height := INF
    
    for hero_name in ["bobbit", "dwarf", "elf", "wizard"]:
        if characters.has(hero_name):
            for hero in characters[hero_name]:
                if hero.position.y < highest_hero_height:
                    highest_hero_height = hero.position.y
                    ring_bearer = hero
    
    if is_instance_valid(previous_ring_bearer):
        previous_ring_bearer.set_is_ring_bearer(false)
    if is_instance_valid(ring_bearer):
        ring_bearer.set_is_ring_bearer(true)


func toss_ring(
        from: Hero,
        to: Hero) -> void:
    var position_start := from.position
    var position_end := \
            to.position if \
            is_instance_valid(to) else \
            left_spawn_point
    
    if is_instance_valid(to):
        # FIXME: -----------------------------------------------
        # - Simulate some custom physics for the ring toss:
        #   - Calculate an initial velocity, and choose some gravity value.
        #   - Then integrate the velocity and position updates each frame,
        #     until the ring is close enough to the recipient.
        #   - Force update the position with an extra delta to match the
        #     recipient's displacement from the last frame.
        pass
    else:
        # FIXME: -----------------------------------------------
        # - Similar to above case, but just use the left spawn point as a
        #   static position.
        # - If animating to spawn while a hero spawns, then redirect to them.
        pass
    
    # FIXME: ---------------------------
    # - Delay hero glow until the ring has reached them.
    
    # FIXME: ------------------------------
    # - Update get_ring_position() to use the current animation position.


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


func on_hero_knocked_off() -> void:
    session.knock_off_count += 1


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


func get_ring_position() -> Vector2:
    return ring_bearer.position if \
            is_instance_valid(ring_bearer) else \
            Vector2.INF


func _on_Goal_body_entered(hero: Hero) -> void:
#    hero.stop()
    _trigger_heroes_win()


class SpawnTimeComparator:
    static func sort(a: Dictionary, b: Dictionary) -> bool:
        return a.time < b.time
