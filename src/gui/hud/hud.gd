tool
class_name Hud
extends SurfacerHud


const HERO_INDICATORS_SCENE := "res://src/gui/hud/hero_indicators.tscn"
const VILLAIN_INDICATORS_SCENE := "res://src/gui/hud/villain_indicators.tscn"
const CONTROL_BUTTONS_SCENE := "res://src/gui/hud/control_buttons.tscn"

var hero_indicators: HeroIndicators
var villain_indicators: VillainIndicators
var control_buttons: ControlButtons


func _ready() -> void:
    self.modulate.a = 0.8


func create_cooldowns() -> void:
    hero_indicators = Sc.utils.add_scene(
            self,
            HERO_INDICATORS_SCENE)
    villain_indicators = Sc.utils.add_scene(
            self,
            VILLAIN_INDICATORS_SCENE)
    control_buttons = Sc.utils.add_scene(
            self,
            CONTROL_BUTTONS_SCENE)


func _destroy() -> void:
    ._destroy()
    if is_instance_valid(hero_indicators):
        hero_indicators._destroy()
    if is_instance_valid(villain_indicators):
        villain_indicators._destroy()
    if is_instance_valid(control_buttons):
        control_buttons._destroy()
