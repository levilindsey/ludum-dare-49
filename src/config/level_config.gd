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
        ],
        shake_cooldown_period = 4.0,
        schedule = [
            {type = "wave", time = 1.0},
            {type = "bobbit", time = 1.0, side = "l"},
            
            {type = "wave", time = 6.0},
            {type = "bobbit", time = 6.0, side = "r"},
            {type = "bobbit", time = 6.0, side = "r"},
            {type = "bobbit", time = 6.0, side = "r"},
            {type = "bobbit", time = 6.0, side = "r"},
            {type = "bobbit", time = 6.0, side = "r"},
            {type = "bobbit", time = 6.0, side = "l"},
            {type = "bobbit", time = 6.0, side = "l"},
        ],
    },
#    "1": {
#        name = "Foo",
#        version = "0.0.1",
#        is_test_level = false,
#        sort_priority = 10,
#        unlock_conditions = "unlocked",
#        scene_path = LEVELS_PATH_PREFIX + "level1.tscn",
#        platform_graph_character_names = [
#            "bobbit",
#        ],
#        intro_choreography = [
#            {
#                is_player_interaction_enabled = false,
#                zoom_multiplier = 0.5,
#            },
#            {
#                duration = 0.3,
#            },
#            {
#                destination = SurfacerLevelConfig \
#                        .INTRO_CHOREOGRAPHY_DESTINATION_GROUP_NAME,
#            },
#            {
#                duration = 0.4,
#                zoom_multiplier = 1.0,
#            },
#            {
#                is_player_interaction_enabled = true,
#            },
#        ],
#    },
#    "2": {
#        name = "Bar",
#        version = "0.0.1",
#        is_test_level = false,
#        sort_priority = 20,
#        unlock_conditions = "finish_previous_level",
#        scene_path = LEVELS_PATH_PREFIX + "level2.tscn",
#        platform_graph_character_names = [
#            "bobbit",
#        ],
#    },
}


func _init().(
        ARE_LEVELS_SCENE_BASED,
        level_manifest) -> void:
    pass
