class_name LevelSession
extends SurfacerLevelSession
# NOTE: Don't store references to nodes that should be destroyed with the
#       level, because this session-state will persist after the level is
#       destroyed.


var _waves := []
var _next_wave_index := 0

var _boulders := []
var _next_boulder_index := 0

var _bobbit_spawns := []
var _dwarf_spawns := []
var _elf_spawns := []
var _wizard_spawns := []

var _next_bobbit_spawn_index := 0
var _next_dwarf_spawn_index := 0
var _next_elf_spawn_index := 0
var _next_wizard_spawn_index := 0

var _hero_count := 0
var _is_hero_spawning_finished := false

var last_tremor_time := -INF
var last_boulder_time := -INF

var knock_off_count := 0


func reset(id: String) -> void:
    .reset(id)
    
    _waves = []
    _next_wave_index = 0
    
    _boulders = []
    _next_boulder_index = 0
    
    _bobbit_spawns = []
    _dwarf_spawns = []
    _elf_spawns = []
    _wizard_spawns = []
    
    _next_bobbit_spawn_index = 0
    _next_dwarf_spawn_index = 0
    _next_elf_spawn_index = 0
    _next_wizard_spawn_index = 0
    
    _hero_count = 0
    _is_hero_spawning_finished = false
    
    last_tremor_time = -INF
    last_boulder_time = -INF
    
    knock_off_count = 0


func get_current_wave_number() -> int:
    return _next_wave_index


func get_wave_count() -> int:
    return _waves.size()


func get_is_hero_in_level(hero_name: String) -> bool:
    var spawn_schedule: Array
    match hero_name:
        "bobbit":
            spawn_schedule = _bobbit_spawns
        "dwarf":
            spawn_schedule = _dwarf_spawns
        "elf":
            spawn_schedule = _elf_spawns
        "wizard":
            spawn_schedule = _wizard_spawns
        _:
            Sc.logger.error()
    return !spawn_schedule.empty()


func get_is_boulder_in_level() -> bool:
    return !_boulders.empty()
