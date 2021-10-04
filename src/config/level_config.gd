tool
class_name LevelConfig
extends SurfacerLevelConfig


const ARE_LEVELS_SCENE_BASED := true

const LEVELS_PATH_PREFIX := "res://src/levels/"

var level_manifest := {
    "1": {
        name = "Level 1",
        version = "0.0.1",
        is_test_level = false,
        sort_priority = 1,
        unlock_conditions = "unlocked",
        scene_path = LEVELS_PATH_PREFIX + "level1.tscn",
        platform_graph_character_names = [
            "bobbit",
            "dwarf",
            "elf",
            "orc",
        ],
        tremor_cooldown_period = 4.0,
        schedule = [
#            {type = "wave", time = 1.0},

            {type = "bobbit", time = 2.0, side = "l"},
            {type = "bobbit", time = 16.0, side = "l"},
            {type = "bobbit", time = 20.0, side = "l"},
            {type = "bobbit", time = 23.0, side = "l"},
            
#            {type = "wave", time = 6.0},

            {type = "bobbit", time = 30.1, side = "l"},
            {type = "bobbit", time = 31.5, side = "l"},
            {type = "dwarf", time = 38.6, side = "r"},
            {type = "dwarf", time = 45.6, side = "r"},
            {type = "elf", time = 34.7, side = "r"},
            {type = "elf", time = 51.7, side = "l"},
            
            {type = "orc", time = 60.7},
            {type = "orc", time = 80.7},
            
            {type = "elf", time = 60.7, side = "l"},
            {type = "dwarf", time = 61.7, side = "r"},
            {type = "elf", time = 63.7, side = "r"},
            {type = "dwarf", time = 65.7, side = "r"},
            {type = "dwarf", time = 66.7, side = "l"},
            {type = "elf", time = 67.7, side = "l"},
            
            {type = "orc",    time = 90},
            {type = "orc",    time = 110},
            
            {type = "elf",    time = 68, side = "l"},
            {type = "dwarf",  time = 69, side = "r"},
            {type = "elf",    time = 71, side = "r"},
            {type = "dwarf",  time = 73, side = "r"},
            {type = "dwarf",  time = 74, side = "l"},
            {type = "elf",    time = 75, side = "l"},

            {type = "boulder", time = 30.7},
            {type = "boulder", time = 85.7},

            {type = "bobbit", time = 77, side = "r"},
            {type = "bobbit", time = 78, side = "l"},
            {type = "bobbit", time = 80, side = "l"},
            {type = "bobbit", time = 81, side = "r"},
            {type = "bobbit", time = 82, side = "l"},
            {type = "bobbit", time = 84, side = "l"},
            {type = "bobbit", time = 85, side = "r"},
            {type = "bobbit", time = 86, side = "l"},
            {type = "bobbit", time = 89, side = "r"},
            {type = "bobbit", time = 90, side = "l"},
            {type = "bobbit", time = 91, side = "r"},
            {type = "bobbit", time = 95, side = "r"},
            {type = "bobbit", time = 96, side = "l"},
            {type = "bobbit", time = 97, side = "r"},
            {type = "bobbit", time = 100, side = "l"},
            {type = "bobbit", time = 101, side = "r"},
            
#            {type = "wave", time = 6.0},

            {type = "bobbit", time = 84, side = "l"},
            {type = "bobbit", time = 88, side = "l"},
            {type = "dwarf",  time = 92, side = "r"},
            {type = "dwarf",  time = 96, side = "l"},
            {type = "dwarf",  time = 100, side = "r"},
            {type = "elf",    time = 97, side = "r"},
            {type = "elf",    time = 93, side = "r"},
        ],
    },
    "2": {
        name = "Level 2",
        version = "0.0.1",
        is_test_level = false,
        sort_priority = 2,
        unlock_conditions = "finish_previous_level",
        scene_path = LEVELS_PATH_PREFIX + "level2.tscn",
        platform_graph_character_names = [
            "bobbit",
            "dwarf",
            "elf",
            "wizard",
            "orc",
        ],
        tremor_cooldown_period = 6.0,
        schedule = [
#            {type = "wave", time = 1.0},

            {type = "bobbit", time = 2.0, side = "l"},
            {type = "bobbit", time = 16.0, side = "l"},
            {type = "bobbit", time = 20.0, side = "l"},
            {type = "bobbit", time = 22.0, side = "l"},
            {type = "bobbit", time = 23.0, side = "l"},
            
#            {type = "wave", time = 6.0},

            {type = "wizard", time = 30.1, side = "l"},
            {type = "bobbit", time = 31.5, side = "l"},
            {type = "dwarf", time = 33.6, side = "r"},
            {type = "dwarf", time = 38.6, side = "r"},
            {type = "elf", time = 47.7, side = "r"},
            {type = "elf", time = 51.7, side = "l"},
            
            {type = "orc", time = 30.7},
            {type = "orc", time = 60.7},
            {type = "orc", time = 80.7},
            
            {type = "elf", time = 60.7, side = "l"},
            {type = "dwarf", time = 61.7, side = "r"},
            {type = "wizard", time = 62.7, side = "l"},
            {type = "elf", time = 64.7, side = "r"},
            {type = "dwarf", time = 65.7, side = "r"},
            {type = "elf", time = 67.7, side = "l"},
            
            {type = "orc",    time = 90},
            {type = "orc",    time = 1},
            {type = "orc",    time = 70},
            
            {type = "elf",    time = 68, side = "l"},
            {type = "dwarf",  time = 69, side = "r"},
            {type = "wizard",  time = 70, side = "l"},
            {type = "elf",    time = 72, side = "r"},
            {type = "dwarf",  time = 74, side = "l"},
            {type = "elf",    time = 75, side = "l"},

            {type = "boulder", time = 1},
            {type = "boulder", time = 20},
            {type = "boulder", time = 85.7},
            {type = "boulder", time = 10.7},

            {type = "bobbit", time = 77, side = "r"},
            {type = "bobbit", time = 78, side = "l"},
            {type = "wizard", time = 85, side = "r"},
            {type = "bobbit", time = 86, side = "l"},
            {type = "bobbit", time = 89, side = "r"},
            {type = "bobbit", time = 91, side = "r"},
            {type = "bobbit", time = 96, side = "l"},
            {type = "bobbit", time = 97, side = "r"},
            {type = "bobbit", time = 100, side = "l"},
            {type = "bobbit", time = 101, side = "r"},
            
#            {type = "wave", time = 6.0},

            {type = "bobbit", time = 84, side = "l"},
            {type = "bobbit", time = 88, side = "l"},
            {type = "dwarf",  time = 92, side = "r"},
            {type = "wizard",  time = 96, side = "l"},
            {type = "dwarf",  time = 100, side = "r"},
            {type = "elf",    time = 97, side = "r"},
            {type = "elf",    time = 93, side = "r"},
        ],
    },
    "3": {
        name = "Level 3",
        version = "0.0.1",
        is_test_level = false,
        sort_priority = 3,
        unlock_conditions = "finish_previous_level",
        scene_path = LEVELS_PATH_PREFIX + "level3.tscn",
        platform_graph_character_names = [
            "bobbit",
            "dwarf",
            "elf",
            "wizard",
            "orc",
            "baldrock",
        ],
        tremor_cooldown_period = 7.0,
        schedule = [
#            {type = "wave", time = 1.0},

            {type = "bobbit", time = 2.0, side = "l"},
            {type = "bobbit", time = 16.0, side = "l"},
            {type = "bobbit", time = 20.0, side = "l"},
            {type = "bobbit", time = 22.0, side = "l"},
            {type = "bobbit", time = 23.0, side = "l"},
            
#            {type = "wave", time = 6.0},

            {type = "bobbit", time = 30.1, side = "l"},
            {type = "bobbit", time = 31.5, side = "l"},
            {type = "wizard", time = 33.6, side = "r"},
            {type = "dwarf", time = 38.6, side = "r"},
            {type = "elf", time = 34.7, side = "r"},
            {type = "elf", time = 51.7, side = "l"},
            
            {type = "orc", time = 60.7},
            {type = "orc", time = 80.7},
            
            {type = "elf", time = 60.7, side = "l"},
            {type = "dwarf", time = 61.7, side = "r"},
            {type = "wizard", time = 63.7, side = "r"},
            {type = "elf", time = 64.7, side = "r"},
            {type = "dwarf", time = 66.7, side = "l"},
            {type = "elf", time = 67.7, side = "l"},
            
            {type = "orc",    time = 90},
            {type = "orc",    time = 1},
            {type = "orc",    time = 70},
            
            {type = "elf",    time = 68, side = "l"},
            {type = "dwarf",  time = 69, side = "r"},
            {type = "wizard",  time = 70, side = "l"},
            {type = "elf",    time = 71, side = "r"},
            {type = "dwarf",  time = 73, side = "r"},
            {type = "elf",    time = 75, side = "l"},

            {type = "boulder", time = 2},
            {type = "boulder", time = 30.7},
            {type = "boulder", time = 1},
            {type = "boulder", time = 20},
            {type = "boulder", time = 85.7},
            
            {type = "baldrock", time = 15.7},
            {type = "baldrock", time = 40.7},
            {type = "baldrock", time = 8},
            {type = "baldrock", time = 80.7},

            {type = "bobbit", time = 77, side = "r"},
            {type = "bobbit", time = 78, side = "l"},
            {type = "bobbit", time = 83, side = "r"},
            {type = "bobbit", time = 84, side = "l"},
            {type = "bobbit", time = 85, side = "r"},
            {type = "bobbit", time = 89, side = "r"},
            {type = "bobbit", time = 90, side = "l"},
            {type = "bobbit", time = 92, side = "l"},
            {type = "wizard", time = 93, side = "r"},
            {type = "bobbit", time = 94, side = "l"},
            {type = "bobbit", time = 95, side = "r"},
            {type = "bobbit", time = 98, side = "l"},
            {type = "wizard", time = 99, side = "r"},
            {type = "bobbit", time = 100, side = "l"},
            {type = "bobbit", time = 101, side = "r"},
            
#            {type = "wave", time = 6.0},

            {type = "bobbit", time = 84, side = "l"},
            {type = "wizard", time = 84, side = "l"},
            {type = "bobbit", time = 88, side = "l"},
            {type = "dwarf",  time = 92, side = "r"},
            {type = "dwarf",  time = 96, side = "l"},
            {type = "dwarf",  time = 100, side = "r"},
            {type = "elf",    time = 97, side = "r"},
            {type = "elf",    time = 93, side = "r"},
        ],
    },
}


func _init().(
        ARE_LEVELS_SCENE_BASED,
        level_manifest) -> void:
    pass
