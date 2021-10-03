tool
class_name Level
extends SurfacerLevel


const _BOULDER_PLATFORM_SELECTION_MAX_DISTANCE := 48.0

var eye: Eye
var goal: Area2D
var goal_position: PositionAlongSurface
var left_spawn_point: Vector2
var right_spawn_point: Vector2
var mountain_container: Node2D
var shaker: Shaker
var crash_test_dummy: CrashTestDummy
var tile_map_original: SimpleTileMap
var tile_map_copy: TileMap

var ring_bearer: Hero

var is_in_boulder_selection_mode := false
var is_in_orc_selection_mode := false
var is_in_baldrock_selection_mode := false


func _load() -> void:
    ._load()
    
    Sc.gui.hud.create_cooldowns()


func _on_intro_choreography_finished() -> void:
    ._on_intro_choreography_finished()
    # Immediately hide the welcome panel.
    _hide_welcome_panel()


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
    
    mountain_container = get_node("MountainContainer")
    assert(is_instance_valid(mountain_container))
    
    shaker = Shaker.new()
    add_child(shaker)
    
    crash_test_dummy = \
            graph_parser.crash_test_dummies.bobbit if \
            graph_parser.crash_test_dummies.has("bobbit") else \
            graph_parser.crash_test_dummies.values()[0]
    
    goal_position = SurfaceFinder.find_closest_position_on_a_surface(
            goal.position,
            crash_test_dummy,
            SurfaceReachability.ANY)
    
    eye.set_direction(EyeDirection.DOWN)
    
    ._start()
    
    _setup_tile_map_copy()


func _setup_tile_map_copy() -> void:
    tile_map_original = get_node("SimpleTileMap")
    tile_map_original.z_index = -1000
    
    tile_map_copy = TileMap.new()
    tile_map_copy.tile_set = tile_map_original.tile_set
    tile_map_copy.cell_size = tile_map_original.cell_size
    tile_map_copy.cell_quadrant_size = tile_map_original.cell_quadrant_size
    tile_map_copy.collision_layer = 0
    tile_map_copy.collision_mask = 0
    
    var used_cells := tile_map_original.get_used_cells()
    for cell_position in used_cells:
        var tile_set_index := tile_map_original.get_cellv(cell_position)
        var autotile_coord := tile_map_original.get_cell_autotile_coord(
                cell_position.x,
                cell_position.y)
        tile_map_copy.set_cell(
                cell_position.x,
                cell_position.y,
                tile_set_index,
                false,
                false,
                false,
                autotile_coord)
    
    mountain_container.add_child(tile_map_copy)


func _parse_schedule() -> void:
    assert(session.config.has("schedule"))
    assert(session.config.has("tremor_cooldown_period"))
    
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
            "boulder":
                session._boulders.push_back(event)
            "orc":
                session._orcs.push_back(event)
            "baldrock":
                session._baldrocks.push_back(event)
            _:
                Sc.logger.error()
    
    session._bobbit_spawns.sort_custom(SpawnTimeComparator, "sort")
    session._dwarf_spawns.sort_custom(SpawnTimeComparator, "sort")
    session._elf_spawns.sort_custom(SpawnTimeComparator, "sort")
    session._wizard_spawns.sort_custom(SpawnTimeComparator, "sort")
    session._waves.sort_custom(SpawnTimeComparator, "sort")
    session._boulders.sort_custom(SpawnTimeComparator, "sort")
    session._orcs.sort_custom(SpawnTimeComparator, "sort")
    session._baldrocks.sort_custom(SpawnTimeComparator, "sort")


func _physics_process(_delta: float) -> void:
    if Su.is_precomputing_platform_graphs or \
            Sc.level_session._is_destroyed:
        return
    
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
    
    var bobbit_active_count := _get_hero_active_count("bobbit")
    var dwarf_active_count := _get_hero_active_count("dwarf")
    var elf_active_count := _get_hero_active_count("elf")
    var wizard_active_count := _get_hero_active_count("wizard")
    
    var bobbit_remaining_count := _get_event_remaining_count(
            session._bobbit_spawns,
            session._next_bobbit_spawn_index)
    var dwarf_remaining_count := _get_event_remaining_count(
            session._dwarf_spawns,
            session._next_dwarf_spawn_index)
    var elf_remaining_count := _get_event_remaining_count(
            session._elf_spawns,
            session._next_elf_spawn_index)
    var wizard_remaining_count := _get_event_remaining_count(
            session._wizard_spawns,
            session._next_wizard_spawn_index)
    
    var wave_remaining_count := _get_event_remaining_count(
            session._waves,
            session._next_wave_index)
    var boulder_remaining_count := _get_event_remaining_count(
            session._boulders,
            session._next_boulder_index)
    var orc_remaining_count := _get_event_remaining_count(
            session._orcs,
            session._next_orc_index)
    var baldrock_remaining_count := _get_event_remaining_count(
            session._baldrocks,
            session._next_baldrock_index)
    var tremor_remaining_count := INF
    
    var bobbit_cooldown_progress := _get_schedule_progress(
            current_time,
            session._bobbit_spawns,
            session._next_bobbit_spawn_index)
    var dwarf_cooldown_progress := _get_schedule_progress(
            current_time,
            session._dwarf_spawns,
            session._next_dwarf_spawn_index)
    var elf_cooldown_progress := _get_schedule_progress(
            current_time,
            session._elf_spawns,
            session._next_elf_spawn_index)
    var wizard_cooldown_progress := _get_schedule_progress(
            current_time,
            session._wizard_spawns,
            session._next_wizard_spawn_index)
    
    var wave_cooldown_progress := _get_schedule_progress(
            current_time,
            session._waves,
            session._next_wave_index)
    var tremor_cooldown_progress := min(1.0,
            (current_time - session.last_tremor_time) / \
            session.config.tremor_cooldown_period)
    var boulder_cooldown_progress := _get_schedule_progress(
            current_time,
            session._boulders,
            session._next_boulder_index)
    var orc_cooldown_progress := _get_schedule_progress(
            current_time,
            session._orcs,
            session._next_orc_index)
    var baldrock_cooldown_progress := _get_schedule_progress(
            current_time,
            session._baldrocks,
            session._next_baldrock_index)
    
    var is_tremor_button_enabled := \
            tremor_cooldown_progress >= 1.0 and \
            !Sc.level_session.is_ended
    var is_boulder_button_enabled := \
            boulder_cooldown_progress >= 1.0 and \
            !Sc.level_session.is_ended and \
            !is_in_boulder_selection_mode
    var is_orc_button_enabled := \
            orc_cooldown_progress >= 1.0 and \
            !Sc.level_session.is_ended and \
            !is_in_orc_selection_mode
    var is_baldrock_button_enabled := \
            baldrock_cooldown_progress >= 1.0 and \
            !Sc.level_session.is_ended and \
            !is_in_baldrock_selection_mode
    
    Sc.gui.hud.hero_indicators.update_indicator(
            "bobbit",
            bobbit_cooldown_progress,
            bobbit_remaining_count)
    Sc.gui.hud.hero_indicators.update_indicator(
            "dwarf",
            dwarf_cooldown_progress,
            dwarf_remaining_count)
    Sc.gui.hud.hero_indicators.update_indicator(
            "elf",
            elf_cooldown_progress,
            elf_remaining_count)
    Sc.gui.hud.hero_indicators.update_indicator(
            "wizard",
            wizard_cooldown_progress,
            wizard_remaining_count)
    
    Sc.gui.hud.hero_indicators.update_indicator(
            "wave",
            wave_cooldown_progress,
            wave_remaining_count)
    Sc.gui.hud.villain_indicators.update_indicator(
            "tremor",
            tremor_cooldown_progress,
            tremor_remaining_count)
    Sc.gui.hud.villain_indicators.update_indicator(
            "boulder",
            boulder_cooldown_progress,
            boulder_remaining_count)
    Sc.gui.hud.villain_indicators.update_indicator(
            "orc",
            orc_cooldown_progress,
            orc_remaining_count)
    Sc.gui.hud.villain_indicators.update_indicator(
            "baldrock",
            baldrock_cooldown_progress,
            baldrock_remaining_count)
    
    Sc.gui.hud.control_buttons.set_button_enabled(
            "tremor",
            is_tremor_button_enabled)
    Sc.gui.hud.control_buttons.set_button_enabled(
            "boulder",
            is_boulder_button_enabled)
    Sc.gui.hud.control_buttons.set_button_enabled(
            "orc",
            is_orc_button_enabled)
    Sc.gui.hud.control_buttons.set_button_enabled(
            "baldrock",
            is_baldrock_button_enabled)
    
    session._hero_count = \
            bobbit_active_count + \
            dwarf_active_count + \
            elf_active_count + \
            wizard_active_count
    
    if session._is_hero_spawning_finished and \
            session._hero_count == 0:
        _trigger_heroes_lose()


func _get_hero_active_count(hero_name: String) -> int:
    return characters[hero_name].size() if \
            characters.has(hero_name) else \
            0


func _get_event_remaining_count(
        schedule: Array,
        next_index: int) -> int:
    return schedule.size() - next_index


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


func _get_schedule_progress(
        current_time: float,
        schedule: Array,
        next_index: int) -> float:
    var is_last_event := next_index >= schedule.size()
    var is_first_event := next_index == 0
    
    if is_last_event:
        return INF
    
    var previous_event_time: float = \
            0.0 if \
            is_first_event else \
            schedule[next_index - 1].time
    var next_event_time: float = schedule[next_index].time
    
    return (current_time - previous_event_time) / \
            (next_event_time - previous_event_time)


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
    eye.trigger_narrow()


func trigger_tremor() -> void:
    if Su.is_precomputing_platform_graphs or \
            Sc.level_session._is_destroyed or \
            Sc.level_session.is_ended:
        return
    
    
    
    
    # FIXME: ----------------------------
    # - Add logic to displace heroes.
    #   - Implement more robust fall-down logic!
    #     - Or, maybe they don't need nav from in-air at all, and just grab
    #       whatever they touch first?
    #   - Decide whether they should be ko'd instantly, or if they have a chance
    #     to land on a nearby platform.
    #     - Three options:
    #       - They fall nearly straight down from their current position.
    #         - If standing on a platform, they fall down through/beyond it.
    #         - If jumping, they fall straightish from where they are.
    #         - If there is a landing platform that isn't too far away, they
    #           survive and keep going.
    #       - They get bounced in a random direction.
    #         - Then, they can land and keep going as above.
    #       - They cannot survive the tremor.
    #       - Maybe different heroes fall differently?
    #         - Dwarves: downward (from air)
    #         - Bobbits: bounce
    #         - Elves: downward (from platform)
    #         - Wizards:
    #           - Aren't bothered at all?
    #           - Only boulders and enemies?
    #           - But are super slow (to walk, not jump, they'll need good
    #             in-air acceleration), and take long pauses.
    
    
    
    
    shaker.shake(mountain_container, 0.5)
    Sc.time.set_timeout(funcref(self, "_trigger_delayed_tremor"), 0.4)
    
    session.last_tremor_time = Sc.time.get_scaled_play_time()
    Sc.gui.hud.control_buttons.set_button_enabled("tremor", false)


func _trigger_delayed_tremor() -> void:
    for character_list in characters.values():
        for character in character_list:
            character.on_tremor()
    shaker.shake(mountain_container)


func trigger_boulder_selection_mode() -> void:
    if Su.is_precomputing_platform_graphs or \
            Sc.level_session._is_destroyed or \
            Sc.level_session.is_ended:
        return
    
    if is_in_boulder_selection_mode:
        return
    
    is_in_boulder_selection_mode = true
    
    Sc.gui.hud.control_buttons.set_button_enabled("boulder", false)


func trigger_orc_selection_mode() -> void:
    if Su.is_precomputing_platform_graphs or \
            Sc.level_session._is_destroyed or \
            Sc.level_session.is_ended:
        return
    
    if is_in_orc_selection_mode:
        return
    
    is_in_orc_selection_mode = true
    
    Sc.gui.hud.control_buttons.set_button_enabled("orc", false)


func trigger_baldrock_selection_mode() -> void:
    if Su.is_precomputing_platform_graphs or \
            Sc.level_session._is_destroyed or \
            Sc.level_session.is_ended:
        return
    
    if is_in_baldrock_selection_mode:
        return
    
    is_in_baldrock_selection_mode = true
    
    Sc.gui.hud.control_buttons.set_button_enabled("baldrock", false)


func _unhandled_input(event: InputEvent) -> void:
    if Engine.editor_hint:
        return
    
    if !is_in_boulder_selection_mode:
        return
    
    # FIXME: ----------------------------
    # - Highlight on finger down as a stretch goal.
    
    if event is InputEventMouseButton or \
            event is InputEventScreenTouch:
        var touch_position := Sc.utils.get_level_touch_position(event)
        var closest_position := \
                SurfaceFinder.find_closest_position_on_a_surface(
                        touch_position,
                        crash_test_dummy,
                        SurfaceReachability.ANY,
                        _BOULDER_PLATFORM_SELECTION_MAX_DISTANCE)
        var is_valid := is_instance_valid(closest_position)
        var surface := \
                closest_position.surface if \
                is_valid else \
                null
        Sc.annotators.add_transient(SurfacerClickAnnotator.new(
                touch_position,
                surface,
                is_valid))
        
        if is_valid:
            _drop_boulder(surface)


func _drop_boulder(surface: Surface) -> void:
    assert(surface.side == SurfaceSide.FLOOR)
    
    if !is_in_boulder_selection_mode:
        return
    
    is_in_boulder_selection_mode = false
    session.last_boulder_time = Sc.time.get_scaled_play_time()
    Sc.gui.hud.control_buttons.set_button_enabled("boulder", false)
    
    # Update the platform-graph surface-exclusion lists.
    for graph in graph_parser.platform_graphs.values():
        graph.update_surface_exclusion(surface, true)
    
    # -   Replace the old tiles in the tile maps with an empty value.
    # -   Simply removing the tiles might break some calculations that are
    #     based on the tile-map's bounds.
    var empty_tile_id: int = \
            tile_map_original.tile_set.find_tile_by_name("empty_tile")
    for tilemap_index in surface.tile_map_indices:
        var tile_coord := Sc.geometry.get_grid_coord_from_tile_map_index(
                tilemap_index,
                tile_map_original)
        tile_map_original.set_cellv(tile_coord, empty_tile_id)
        tile_map_copy.set_cellv(tile_coord, empty_tile_id)
    
    
    
    
    # FIXME: ---------------------------------
    # - Animate boulder falling.
    # - Animate a mini mountain shake.
    # - Detect collisions with any heros on the way down.
    # - Detect any nearby heros when the boulder lands.
    # - Create a boulder explosion animation.
    # - Create a platform crumble animation.
    
    
    
    
    pass


func _dispatch_orc(surface: Surface) -> void:
    assert(surface.side == SurfaceSide.FLOOR)
    
    if !is_in_orc_selection_mode:
        return
    
    is_in_orc_selection_mode = false
    session.last_orc_time = Sc.time.get_scaled_play_time()
    Sc.gui.hud.control_buttons.set_button_enabled("orc", false)
    
    # FIXME: ----------------------------
    pass


func _dispatch_baldrock(surface: Surface) -> void:
    assert(surface.side == SurfaceSide.FLOOR)
    
    if !is_in_baldrock_selection_mode:
        return
    
    is_in_baldrock_selection_mode = false
    session.last_baldrock_time = Sc.time.get_scaled_play_time()
    Sc.gui.hud.control_buttons.set_button_enabled("baldrock", false)
    
    # FIXME: ----------------------------
    pass


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
        quit(false, false)


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
    if Su.is_precomputing_platform_graphs or \
            Sc.level_session._is_destroyed or \
            Sc.level_session.is_ended:
        return
    
#    hero.stop()
    _trigger_heroes_win()


class SpawnTimeComparator:
    static func sort(a: Dictionary, b: Dictionary) -> bool:
        return a.time < b.time
