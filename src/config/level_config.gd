tool
class_name LevelConfig
extends SurfacerLevelConfig


const ARE_LEVELS_SCENE_BASED := true

const LEVELS_PATH_PREFIX := "res://src/levels/"

var level_manifest := {
    "0": {
        name = "Test",
        version = "0.0.1",
        is_test_level = true,
        sort_priority = -100,
        unlock_conditions = "unlocked",
        scene_path = LEVELS_PATH_PREFIX + "level0.tscn",
        platform_graph_character_names = [
            "bobbit",
            "dwarf",
            "elf",
            "wizard",
        ],
        tremor_cooldown_period = 6.0,
        schedule = [
            {type = "wave", time = 1.0},
            {type = "bobbit", time = 1.0, side = "l"},
            
            {type = "wave", time = 6.0},
            {type = "bobbit", time = 6.1, side = "r"},
            {type = "bobbit", time = 6.2, side = "l"},
            {type = "bobbit", time = 6.3, side = "r"},
            {type = "wizard", time = 6.4, side = "r"},
            {type = "bobbit", time = 6.5, side = "r"},
            {type = "dwarf", time = 6.6, side = "l"},
            {type = "elf", time = 6.7, side = "l"},
        ],
    },
    "1": {
        name = "Test",
        version = "0.0.1",
        is_test_level = true,
        sort_priority = -99,
        unlock_conditions = "unlocked",
        scene_path = LEVELS_PATH_PREFIX + "level1.tscn",
        platform_graph_character_names = [
            "bobbit",
            "dwarf",
            "elf",
            "wizard",
            "orc",
            "baldrock",
        ],
        tremor_cooldown_period = 6.0,
        schedule = [
#            {type = "wave", time = 1.0},
            {type = "bobbit", time = 1.0, side = "l"},
            {type = "bobbit", time = 4.0, side = "l"},
            
            {type = "boulder", time = 1.0},
            {type = "boulder", time = 3.0},
            {type = "boulder", time = 4.0},
            {type = "boulder", time = 5.0},
            {type = "boulder", time = 7.0},
            {type = "boulder", time = 11.0},
            {type = "boulder", time = 16.0},
            {type = "boulder", time = 20.0},
            {type = "boulder", time = 26.0},
#            {type = "boulder", time = 44.0},
#            {type = "boulder", time = 38.0},
#            {type = "boulder", time = 32.0},
#            {type = "boulder", time = 26.0},
#            {type = "boulder", time = 20.0},
#            {type = "boulder", time = 14.0},
#            {type = "boulder", time = 8.0},
            {type = "orc", time = 2.0},
            {type = "orc", time = 8.0},
            {type = "baldrock", time = 2.0},
            {type = "baldrock", time = 6.0},
            {type = "baldrock", time = 12.0},
            
#            {type = "wave", time = 6.0},
            {type = "bobbit", time = 6.1, side = "r"},
            {type = "bobbit", time = 7.2, side = "l"},
            {type = "bobbit", time = 7.3, side = "r"},
            {type = "wizard", time = 6.4, side = "r"},
            {type = "bobbit", time = 6.5, side = "r"},
            {type = "dwarf", time = 6.6, side = "l"},
            {type = "elf", time = 6.7, side = "l"},
            
#            {type = "wave", time = 12.0},
            {type = "elf", time = 12.1, side = "r"},
            {type = "dwarf", time = 12.2, side = "l"},
            {type = "bobbit", time = 13.3, side = "r"},
            {type = "wizard", time = 13.4, side = "r"},
            {type = "bobbit", time = 12.5, side = "r"},
            {type = "dwarf", time = 12.6, side = "l"},
            {type = "elf", time = 12.7, side = "l"},
        ],
    },
}


func _init().(
        ARE_LEVELS_SCENE_BASED,
        level_manifest) -> void:
    pass
