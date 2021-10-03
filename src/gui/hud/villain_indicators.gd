tool
class_name VillainIndicators
extends VBoxContainer


const _SEPARATION := 4.0

var cooldown_count := 0


func _ready() -> void:
    Sc.gui.add_gui_to_scale(self)
    _on_gui_scale_changed()


func on_schedule_ready() -> void:
    $BoulderCooldown.visible = false
    $OrcCooldown.visible = false
    $BaldrockCooldown.visible = false
    
    cooldown_count = 1
    
    if Sc.level_session.get_is_boulder_in_level():
        $BoulderCooldown.visible = true
        cooldown_count += 1
    if Sc.level_session.get_is_orc_in_level():
        $OrcCooldown.visible = true
        cooldown_count += 1
    if Sc.level_session.get_is_baldrock_in_level():
        $BaldrockCooldown.visible = true
        cooldown_count += 1
    
    _on_gui_scale_changed()


func _destroy() -> void:
    Sc.gui.remove_gui_to_scale(self)
    if !is_queued_for_deletion():
        queue_free()


func _on_gui_scale_changed() -> bool:
    call_deferred("_on_gui_scale_changed_deferred")
    return true


func _on_gui_scale_changed_deferred() -> void:
    for child in Sc.utils.get_children_by_type(self, Control):
        Sc.gui.scale_gui_recursively(child)
    
    var cooldown_size: Vector2 = $TremorCooldown.rect_size
    
    rect_size.x = cooldown_size.x
#    rect_size.y = \
#            cooldown_size.y * cooldown_count + \
#            _SEPARATION * (cooldown_count + 1)
    
    rect_position.x = \
            HudKeyValueBox.SEPARATION * Sc.gui.scale
    rect_position.y = \
            Sc.gui.hud.hud_key_value_list.get_bottom_coordinate() + \
            (HudKeyValueBox.SEPARATION * Sc.gui.scale) * 3.0 if \
            is_instance_valid(Sc.gui.hud.hud_key_value_list) else \
            (HudKeyValueBox.SEPARATION * Sc.gui.scale)
            


func update_indicator(
        indicator_name: String,
        cooldown_progress: float,
        count: int) -> void:
    var indicator := get_cooldown_indicator(indicator_name)
    indicator.set_progress(cooldown_progress)
    indicator.set_count(count)


func get_cooldown_indicator(indicator_name: String) -> CooldownIndicator:
    match indicator_name:
        "tremor":
            return $TremorCooldown as CooldownIndicator
        "boulder":
            return $BoulderCooldown as CooldownIndicator
        "orc":
            return $OrcCooldown as CooldownIndicator
        "baldrock":
            return $BaldrockCooldown as CooldownIndicator
        _:
            Sc.logger.error()
            return null
