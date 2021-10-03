class_name LevelSession
extends SurfacerLevelSession
# NOTE: Don't store references to nodes that should be destroyed with the
#       level, because this session-state will persist after the level is
#       destroyed.


var _bobbit_spawns := []
var _dwarf_spawns := []
var _elf_spawns := []
var _wizard_spawns := []
var _waves := []
var _boulders := []
var _orcs := []
var _baldrocks := []

var _next_bobbit_spawn_index := 0
var _next_dwarf_spawn_index := 0
var _next_elf_spawn_index := 0
var _next_wizard_spawn_index := 0
var _next_wave_index := 0
var _next_boulder_index := 0
var _next_orc_index := 0
var _next_baldrock_index := 0

var last_tremor_time := -INF

var is_tremor_ready := false
var is_boulder_ready := false
var is_orc_ready := false
var is_baldrock_ready := false

var _hero_count := 0
var _is_hero_spawning_finished := false

var knock_off_count := 0


func reset(id: String) -> void:
    .reset(id)
    
    _bobbit_spawns = []
    _dwarf_spawns = []
    _elf_spawns = []
    _wizard_spawns = []
    _waves = []
    _boulders = []
    _orcs = []
    _baldrocks = []
    
    _next_bobbit_spawn_index = 0
    _next_dwarf_spawn_index = 0
    _next_elf_spawn_index = 0
    _next_wizard_spawn_index = 0
    _next_wave_index = 0
    _next_boulder_index = 0
    _next_orc_index = 0
    _next_baldrock_index = 0
    
    last_tremor_time = -INF

    is_tremor_ready = false
    is_boulder_ready = false
    is_orc_ready = false
    is_baldrock_ready = false
    
    _hero_count = 0
    _is_hero_spawning_finished = false
    
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


func get_is_orc_in_level() -> bool:
    return !_orcs.empty()


func get_is_baldrock_in_level() -> bool:
    return !_baldrocks.empty()
