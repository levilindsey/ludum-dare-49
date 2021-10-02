tool
class_name Hud
extends SurfacerHud


const HERO_INDICATORS_SCENE := "res://src/gui/hud/hero_indicators.tscn"
const VILLAIN_INDICATORS_SCENE := "res://src/gui/hud/villain_indicators.tscn"

var hero_indicators: HeroIndicators
var villain_indicators: VillainIndicators


func create_cooldowns() -> void:
    hero_indicators = Sc.utils.add_scene(
            self,
            HERO_INDICATORS_SCENE)
    villain_indicators = Sc.utils.add_scene(
            self,
            VILLAIN_INDICATORS_SCENE)


func _destroy() -> void:
    ._destroy()
    if is_instance_valid(hero_indicators):
        hero_indicators._destroy()
    if is_instance_valid(villain_indicators):
        villain_indicators._destroy()
